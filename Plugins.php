<?php

namespace Template\Snackys;

use Illuminate\Support\Collection;
use JTL\Cache\JTLCacheInterface;
use JTL\Catalog\Category\Kategorie;
use JTL\Catalog\Category\KategorieListe;
use JTL\Catalog\Product\Artikel;
use JTL\Catalog\Product\Preise;
use JTL\CheckBox;
use JTL\DB\DbInterface;
use JTL\Filter\Config;
use JTL\Filter\ProductFilter;
use JTL\Helpers\Category;
use JTL\Helpers\Manufacturer;
use JTL\Helpers\Seo;
use JTL\Helpers\Tax;
use JTL\Link\Link;
use JTL\Link\LinkGroupInterface;
use JTL\Media\Image;
use JTL\Media\Image\Product;
use JTL\Session\Frontend;
use JTL\Shop;
use JTL\Staat;
use JTL\Template;
use JTL\Template\Model;
use JTL\Template\XMLReader;
use Smarty_Internal_Data;

/**
 * Class Plugins
 * @package Template\Snackys
 */
class Plugins
{
    /**
     * @var DbInterface
     */
    private $db;

    /**
     * @var JTLCacheInterface
     */
    private $cache;

    /**
     * @var Model
     */
    private $template;

    /**
     * Plugins constructor.
     * @param DbInterface       $db
     * @param JTLCacheInterface $cache
     */
    public function __construct(DbInterface $db, JTLCacheInterface $cache, Model $template)
    {
        $this->db    = $db;
        $this->cache = $cache;
        $this->template = $template;
		$this->checkPluginExists();
    }
	public function consentSeen($params, $smarty)
	{
		echo "Youtube: ".Shop::Container()->getConsentManager()->hasConsent("youtube");
		/*
		echo "<pre>";
		print_r(Shop::Container()->getConsentManager()->getConsents());
		echo "</pre>";
		*/
		
		return false;
	}
	
	protected function checkPluginExists()
	{
		$snackys = $this->db->query('SELECT nStatus FROM tplugin WHERE cVerzeichnis=\'km_snackys\'',1);
		if(!$snackys || !isset($snackys->nStatus) || $snackys->nStatus != 2)
		
		//Noch die alte Methode erstmal:
		die('<html><head><title>Snackys Template</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
		<style type="text/css">
		body {font-family:\'Source Sans Pro\',\'Helvetica Neue\',\'Helvetica\',\'Arial\',sans-serif;}
		#box {max-width: 900px; margin: 0 auto;margin-top: 80px;width:80%;}
		h2 {background: linear-gradient( 90deg, rgb(255,94,77) 0%, rgb(255,131,77) 0%, rgb(255,154,86) 0%, rgb(248,85,88) 100%); color: #fff;margin:0;padding: 20px 50px;}
		p {padding: 50px; background: #f0f0f0;margin:0;}
		</style></head><body><div id="box"><h2>Herzlichen Gl&uuml;ckwunsch.</h2><p>Du hast erfolgreich dein neues Snackys Template aktiviert.<br><br>Bitte installiere nun noch das Hilfsplugin um deinen Shop im schicken und schnellem Design zu sehen: <a href="https://www.jtl-software.de/extension-store/hilfsplugin-fuer-snackys-template-das-schnellste-shop5-template-jtl-shop-5">https://www.jtl-software.de/extension-store/hilfsplugin-fuer-snackys-template-das-schnellste-shop5-template-jtl-shop-5</a></p></div></body></html>');

	}
	
	//Alte Funktionen
	public function get_trustedshops_data($params, $smarty)
	{
	}
	private function getOPCSubs($contents)
	{
		$items = array();
			$areas = $contents->getAreas();
		foreach($areas as $area)
		{
			$contents = $area->getContent();
			foreach($contents as $content)
			{
				$item = $content->getPortlet();
				$items[] = str_replace("JTL\\OPC\\Portlets\\","",get_class($item));
				$subs = $content->getSubareaList();
				if($subs)
					$items = array_merge($this->getOPCSubs($subs),$items);
			}
		}
		
		return $items;
	}
	
	public function getActiveOPCItems($params, $smarty)
	{
		$opc = Shop::Container()->getOPCPageService();
		$areas = $opc->getCurPage()->getAreaList()->getAreas();
		$items = array();
		foreach($areas as $area)
		{
			$contents = $area->getContent();
			foreach($contents as $content)
			{
				$item = $content->getPortlet();
				$items[] = str_replace("JTL\\OPC\\Portlets\\","",get_class($item));
				$subs = $content->getSubareaList();
				if($subs)
					$items = array_merge($this->getOPCSubs($subs),$items);
			}
			
			//Beim Portlet dann noch: getSubareaList
		}
		$smarty->assign($params['cAssign'],array_unique($items));
	}
	
	public function getDeliveryDate($params, $smarty)
	{
		$return = "";
		
		$startDate = time();
		
		$land = substr($params['state'],0,2);
		$state = substr($params['state'],3);
		$format = isset($params['format']) ? $params['format'] : 'd.m.Y';
		$saturday = isset($params['saturday']) ? (int)$params['saturday'] : 1;
		$endTime = isset($params['endTime']) ? (int)$params['endTime'] : 0;
		
		if($endTime > 0 && $endTime <= date('Hi',$startDate))
			$startDate = $startDate + (60*60*24);
		
		//Ist heute ein Feiertag? Wenn ja, geht es ja erst darauf los
		$today = $this->getNextWorkingDay($startDate,$land,$state,($saturday == 1 || $saturday==3));
		
		$days = (int) $params['days'];
		
		for($i=0;$i<$days;$i++)
		{
			$startDate = $this->getNextWorkingDay($startDate,$land,$state,($saturday == 1 || $saturday==2));
		}
		
		$return = date($format,$startDate);
		
		if(isset($params['cAssign']))
			$smarty->assign($params['cAssign'],$return);
		else
			return $return;
			
	}
	
	private function getNextWorkingDay($startDate,$country,$state,$saturday)
	{
		$startDate = $startDate + (60*60*24);		//1 Tag hinzufügen
		if($country == 'DE')
			$tagTyp = $this->feiertagDE(date('Y-m-d',$startDate),$state);
		elseif($country == 'AT')
			$tagTyp = $this->feiertagAT(date('Y-m-d',$startDate),$state);
		else
			$tagTyp = 'Arbeitstag';
		
		
		if(!($tagTyp == 'Arbeitstag' || ($tagTyp == 'Samstag' && $saturday)))
			$startDate = $this->getNextWorkingDay($startDate,$country,$state,$saturday);
		
		return $startDate;
	}
	
	private function feiertagDE($datum, $bundesland='')
	{
		$bundesland = strtoupper($bundesland);
		if (is_object($datum))
		{
			$datum = date("Y-m-d", $datum);
		}
		$datum = explode("-", $datum);

		$datum[1] = str_pad($datum[1], 2, "0", STR_PAD_LEFT);
		$datum[2] = str_pad($datum[2], 2, "0", STR_PAD_LEFT);

		if (!checkdate($datum[1], $datum[2], $datum[0])) return false;

		$datum_arr = getdate(mktime(0,0,0,$datum[1],$datum[2],$datum[0]));

		$easter_d = date("d", easter_date($datum[0]));
		$easter_m = date("m", easter_date($datum[0]));

		$status = 'Arbeitstag';
		if ($datum_arr['wday'] == 0) $status = 'Sonntag';
		if ($datum_arr['wday'] == 6) $status = 'Samstag';

		if ($datum[1].$datum[2] == '0101')
		{
			return 'Neujahr';
		}
		elseif ($datum[1].$datum[2] == '0106'
			&& ($bundesland == 'BW' || $bundesland == 'BY' || $bundesland == 'ST'))
		{
			return 'Heilige Drei Könige';
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d-2,$datum[0])))
		{
			return 'Karfreitag';
		}
		elseif ($datum[1].$datum[2] == $easter_m.$easter_d)
		{
			return 'Ostersonntag';
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+1,$datum[0])))
		{
			return 'Ostermontag';
		}
		elseif ($datum[1].$datum[2] == '0501')
		{
			return 'Erster Mai';
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+39,$datum[0])))
		{
			return 'Christi Himmelfahrt';
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+49,$datum[0])))
		{
			return 'Pfingstsonntag';
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+50,$datum[0])))
		{
			return 'Pfingstmontag';
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+60,$datum[0]))
			&& ($bundesland == 'BW' || $bundesland == 'BY' || $bundesland == 'HE' || $bundesland == 'NW' || $bundesland == 'RP' || $bundesland == 'SL' || $bundesland == 'SN' || $bundesland == 'TH'))
		{
			return 'Fronleichnam';
		}
		elseif ($datum[1].$datum[2] == '0815'
			&& ($bundesland == 'SL' || $bundesland == 'BY'))
		{
			return 'Mariä Himmelfahrt';
		}
		elseif ($datum[1].$datum[2] == '1003')
		{
			return 'Tag der deutschen Einheit';
		}
		elseif ($datum[1].$datum[2] == '1031'
			&& ($bundesland == 'BB' || $bundesland == 'MV' || $bundesland == 'SN' || $bundesland == 'ST' || $bundesland == 'TH'))
		{
			return 'Reformationstag';
		}
		elseif ($datum[1].$datum[2] == '1101'
			&& ($bundesland == 'BW' || $bundesland == 'BY' || $bundesland == 'NW' || $bundesland == 'RP' || $bundesland == 'SL'))
		{
			return 'Allerheiligen';
		}
		elseif ($datum[1].$datum[2] == strtotime("-11 days", strtotime("1 sunday", mktime(0,0,0,11,26,$datum[0]))) 
			&& $bundesland == 'SN')
		{
			return 'Buß- und Bettag';
		}
		/*elseif ($datum[1].$datum[2] == '1224')
		{
			return 'Heiliger Abend (Bankfeiertag)';
		}*/
		elseif ($datum[1].$datum[2] == '1225')
		{
			return '1. Weihnachtsfeiertag';
		}
		elseif ($datum[1].$datum[2] == '1226')
		{
			return '2. Weihnachtsfeiertag';
		}
		/*elseif ($datum[1].$datum[2] == '1231')
		{
			return 'Silvester (Bankfeiertag)';
		}*/
		else
		{
			return $status;
		}
	}
	
	private function feiertagAT($datum, $bundesland='')
	{ 
		$bundesland = strtoupper($bundesland);
		if (is_object($datum))
		{
			$datum = date("Y-m-d", $datum);
		}
		$datum = explode("-", $datum); 

		$datum[1] = str_pad($datum[1], 2, "0", STR_PAD_LEFT); 
		$datum[2] = str_pad($datum[2], 2, "0", STR_PAD_LEFT); 

		if (!checkdate($datum[1], $datum[2], $datum[0])) return false; 

		$datum_arr = getdate(mktime(0,0,0,$datum[1],$datum[2],$datum[0])); 

		$easter_d = date("d", easter_date($datum[0])); 
		$easter_m = date("m", easter_date($datum[0])); 

		$status = 'Arbeitstag'; 
		if ($datum_arr['wday'] == 0) $status = 'Sonntag';
		if ($datum_arr['wday'] == 6) $status = 'Samstag';

		if ($datum[1].$datum[2] == '0101')
		{ 
			return 'Neujahr'; 
		}
		elseif ($datum[1].$datum[2] == '0106')
		{ 
			return 'Heilige Drei Könige'; 
		}
		elseif ($datum[1].$datum[2] == '0319' && ($bundesland == 'K' || $bundesland == 'ST' || $bundesland == 'T' || $bundesland == 'V'))
		{ 
			return 'Josef'; 
		} 
		elseif ($datum[1].$datum[2] == $easter_m.$easter_d)
		{ 
			return 'Ostersonntag'; 
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+1,$datum[0])))
		{ 
			return 'Ostermontag'; 
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+39,$datum[0])))
		{ 
			return 'Christi Himmelfahrt'; 
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+49,$datum[0])))
		{ 
			return 'Pfingstsonntag'; 
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+50,$datum[0])))
		{ 
			return 'Pfingstmontag'; 
		}
		elseif ($datum[1].$datum[2] == date("md",mktime(0,0,0,$easter_m,$easter_d+60,$datum[0])))
		{ 
			return 'Fronleichnam'; 
		}
		elseif ($datum[1].$datum[2] == '0501')
		{ 
			return 'Erster Mai'; 
		}
		elseif ($datum[1].$datum[2] == '0504' && $bundesland == 'OOE')
		{ 
			return 'Florian'; 
		}
		elseif ($datum[1].$datum[2] == '0815')
		{ 
			return 'Mariä Himmelfahrt'; 
		}
		elseif ($datum[1].$datum[2] == '0924' && $bundesland == 'S')
		{ 
			return 'Rupertitag'; 
		}
		elseif ($datum[1].$datum[2] == '1010' && $bundesland == 'K')
		{ 
			return 'Tag der Volksabstimmung'; 
		}
		elseif ($datum[1].$datum[2] == '1026')
		{ 
			return 'Nationalfeiertag'; 
		}
		elseif ($datum[1].$datum[2] == '1101')
		{ 
			return 'Allerheiligen'; 
		}
		elseif ($datum[1].$datum[2] == '1111' && $bundesland == 'B')
		{ 
			return 'Martini'; 
		}
		elseif ($datum[1].$datum[2] == '1115' && ($bundesland == 'NOE' || $bundesland == 'W'))
		{ 
			return 'Leopoldi'; 
		}
		elseif ($datum[1].$datum[2] == '1208')
		{ 
			return 'Mariä Empfängnis'; 
		}
		/*elseif ($datum[1].$datum[2] == '1224')
		{ 
			return 'Heiliger Abend'; 
		}*/
		elseif ($datum[1].$datum[2] == '1225')
		{ 
			return 'Christtag'; 
		}
		elseif ($datum[1].$datum[2] == '1226')
		{ 
			return 'Stefanitag'; 
		}
		else
		{ 
			return $status; 
		} 
	}

	public function load_boxes_raw($params, &$smarty)
	{
		if (isset($params['array'], $params['assign']) && $params['array'] === true) {
			$rawData = \Boxen::getInstance()->getRawData();
			$smarty->assign($params['assign'], (isset($rawData[$params['type']]) ? $rawData[$params['type']] : null));
		}
	}
	
	public function load_boxes($params, &$smarty)
	{
		$cTplData     = '';
		$cOldTplDir   = '';
		$boxes        = \Boxen::getInstance();
		$oBoxen_arr   = $boxes->compatGet();
		$cTemplateDir = $smarty->getTemplateDir($smarty->context);
			$smarty->assign('boxesPosition',$params['type']);
		if (is_array($oBoxen_arr) && isset($params['type'])) {
			$cType   = $params['type'];
			$_sBoxes = $smarty->getTemplateVars('boxes');
			if (isset($_sBoxes[$cType], $oBoxen_arr[$cType]) && is_array($oBoxen_arr[$cType])) {
				foreach ($oBoxen_arr[$cType] as $oBox) {
					$oPluginVar = '';
					$cTemplate  = 'tpl_inc/boxes/' . $oBox->cTemplate;
					if ($oBox->eTyp === 'plugin') {
						$oPlugin = new \Plugin($oBox->kCustomID);
						if ($oPlugin->kPlugin > 0 && $oPlugin->nStatus == 2) {
							$cTemplate    = $oBox->cTemplate;
							$cOldTplDir   = $cTemplateDir;
							$cTemplateDir = $oPlugin->cFrontendPfad . PFAD_PLUGIN_BOXEN;
							$oPluginVar   = 'oPlugin' . $oBox->kBox;
							$smarty->assign($oPluginVar, $oPlugin);
						}
					} elseif ($oBox->eTyp === 'link') {
						foreach (LinkHelper::getInstance()->getLinkGroups() as $oLinkTpl) {
							if ($oLinkTpl->kLinkgruppe == $oBox->kCustomID) {
								$oBox->oLinkGruppeTemplate = $oLinkTpl;
								$oBox->oLinkGruppe         = $oLinkTpl;
							}
						}
					}
					if (file_exists($cTemplateDir . '/' . $cTemplate)) {
						$oBoxVar = 'oBox' . $oBox->kBox;
						$smarty->assign($oBoxVar, $oBox);
						// Custom Template
						global $Einstellungen;
						if ($Einstellungen['template']['general']['use_customtpl'] === 'Y') {
							$cTemplatePath   = pathinfo($cTemplate);
							$cCustomTemplate = $cTemplatePath['dirname'] . '/' . $cTemplatePath['filename'] . '_custom.tpl';
							if (file_exists($cTemplateDir . '/' . $cCustomTemplate)) {
								$cTemplate = $cCustomTemplate;
							}
						}
						$cTemplatePath = $cTemplateDir . '/' . $cTemplate;
						if ($oBox->eTyp === 'plugin') {
							$cTplData .= "{include file='" . $cTemplatePath . "' oBox=\$$oBoxVar oPlugin=\$$oPluginVar}";
						} else {
							$cTplData .= "{include file='" . $cTemplatePath . "' oBox=\$$oBoxVar}";
						}

						if (strlen($cOldTplDir)) {
							$cTemplateDir = $cOldTplDir;
						}
					}
				}
			}
		}
		if (isset($params['assign'])) {
			$smarty->assign($params['assign'], $cTplData);
			return;
		}

		return $cTplData;
	}

	public function get_img_tag($params, $smarty)
	{
		if (empty($params['src'])) {
			return '';
		}
		$oImgSize = get_image_size($params['src']);

		$imageURL   = $params['src'];
		$imageID    = isset($params['id']) ? ' id="' . $params['id'] . '"' : '';
		$imageALT   = isset($params['alt']) ? ' alt="' . truncate($params['alt'], 75) . '"' : '';
		$imageTITLE = isset($params['title']) ? ' title="' . truncate($params['title'], 75) . '"' : '';
		$imageCLASS = isset($params['class']) ? ' class="' . truncate($params['class'], 75) . '"' : '';
		if (mb_strpos($imageURL, 'http') !== 0) {
			$imageURL = Shop::getImageBaseURL() . ltrim($imageURL, '/');
		}
		if ($oImgSize !== null && $oImgSize->size->width > 0 && $oImgSize->size->height > 0) {
			return '<img src="' . $imageURL . '" width="' . $oImgSize->size->width . '" height="' .
				$oImgSize->size->height . '"' . $imageID . $imageALT . $imageTITLE . $imageCLASS . ' />';
		}

		return '<img src="' . $imageURL . '"' . $imageID . $imageALT . $imageTITLE . $imageCLASS . ' />';
	}
	
	//Snackys Functions
	public function snackys_content($params, $smarty)
	{
		$Einstellungen = Shop::Smarty()->get_template_vars('snackyConfig'); 
		if($Einstellungen['show_content_ids'] == 'Y' && $params['id'] == 'html_body_start' && Shop::isAdmin())
			echo '<div class="dropper-box">Snackys Zone: <strong>html_head_start</strong></div><div class="dropper-box">Snackys Zone: <strong>html_head_end</strong></div>';
		if($Einstellungen['show_content_ids'] == 'Y' && substr($params['id'],0,10) != 'html_head_' && Shop::isAdmin())
			echo "<div class=\"dropper-box\">Snackys Zone: <strong>".$params['id']."</strong></div>";
		
		//Jetzt die Zoneninhalte laden!
		$where = '';
		
		$nSeitenTyp = Shop::Smarty()->get_template_vars('nSeitenTyp');
		$isMobile = Shop::Smarty()->get_template_vars('isMobile');
		$cUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
		//Device
			$where .= ' (nDevice=0 OR nDevice='.( ($isMobile) ? 1 : 2).')';
		//PageType
			$where .= ' AND (nPagetype=0 OR nPagetype='.$nSeitenTyp.')';
		//URL
			$where .= ' AND (nUrl=\'\' OR nUrl=\''.$cUrl.'\')';
		//Language
			$where .= ' AND (nSprache=\'0\' OR nSprache=\'\' OR nSprache=\''.Shop::getLanguage().'\')';
		//Nur aktive
			$where .= ' AND `disabled`=0 ';
			
		$entries = Shop::Container()->getDB()->query('SELECT * FROM `km_snackys_content` WHERE `nZone`=\''.trim($params['id']).'\' AND '.$where.' AND `parent`=0 ORDER BY nSort ASC,cName ASC',2);
		
		if($entries)
		{
			foreach($entries as $entry)
			{
				if($this->checkSnackysContent($entry))
				{
					echo $this->renderSnackysContent($entry,$where);
				}
			}
		}
	}
	
	private function checkSnackysContent($entry)
	{
		$showIt = true;
		if(trim($entry->nPHPIf) != '')
		{
			try{
				//PHP Funktion aufrufen a la $showIt = PHPGHOSTFUNCTION();
				eval('$phpFunc = function(){'.$entry->nPHPIf.'};');
				$showIt = $phpFunc();
			} catch(Exception $e){$showIt = false;}
		}
		if($entry->nPagetype == 1 && $entry->nArtikel != '')
		{
			//Prüfen ob der aktuelle Artikel erlaubt ist
			$articles = explode(';',$entry->nArtikel);
			$Artikel = Shop::Smarty()->get_template_vars('Artikel');
			if(!in_array($Artikel->cArtNr,$articles))
				$showIt = false;
		}
		if($entry->nPagetype == 2 && $entry->nKategorie != 0)
		{
			$AktuelleKategorie = Shop::Smarty()->get_template_vars('AktuelleKategorie');
			if(!$AktuelleKategorie || $entry->nKategorie != $AktuelleKategorie->kKategorie)
				$showIt = false;
		}
		if($entry->nPagetype == 31 && $entry->nPageId > 0)
		{
			$Link = Shop::Smarty()->get_template_vars('Link');
			if(!$Link || $Link->kLink != $entry->nPageId)
				$showIt = false;
		}
		
		return $showIt;
	}
	private function renderSnackysContent($entry,$where)
	{
		$Einstellungen = Shop::Smarty()->get_template_vars('snackyConfig'); 
		$code = '';
		switch($entry->nType)
		{
			case 1:
				if($Einstellungen['optimize_content'] == 'Y')
					$entry->cContent = $this->optimize($entry->cContent);
				$code = Shop::Smarty()->fetch('string:'.$entry->cContent);
				break;
			case 2:
				$data = json_decode($entry->cContent);
				if(!isset($defaultOptions))
					$defaultOptions = Artikel::getDefaultOptions();
				if($data)
				{
					$products = explode(";",$data->products);
					$productList = array();
					foreach($products as $product)
					{
						//Suche nach kArtikel
						$kArtikel = Shop::Container()->getDB()->query('SELECT kArtikel FROM tartikel WHERE cArtNr=\''.trim($product).'\' LIMIT 1',1);
						if($kArtikel)
						{
							$artikel = new Artikel();
							$artikel->fuelleArtikel($kArtikel->kArtikel, $defaultOptions);
							$productList[] = $artikel;
						}
					}
					$sliderTitle = $data->title;
					Shop::Smarty()->assign('snackysProducts',$productList);
					Shop::Smarty()->assign('snackysTitle',$sliderTitle);
					Shop::Smarty()->assign('entry',$entry);
					$code = Shop::Smarty()->fetch('snackys_content/product_slider.tpl');
					//$code = '<div class="snackys-content '.$entry->cClass.'">'.Shop::Smarty()->fetch('string:{include file=\'snippets/product_slider.tpl\' productlist=$tempProducts title=$tempTitle hideOverlays=true}').'</div>';
				}
				break;
			case 3:
				//Gridsystem, also auch dessen Subs laden!
				$subs = Shop::Container()->getDB()->query('SELECT * FROM `km_snackys_content` WHERE '.$where.' AND `parent`='.$entry->id.' ORDER BY nSort ASC,cName ASC',2);
				foreach($subs as $key=>$sub)
				{
					if($this->checkSnackysContent($sub))
						$subs[$key]->rendered = $this->renderSnackysContent($sub,$where);
					
					$config = json_decode($sub->nConfig);
					$subs[$key]->xs = $config->xs;
					$subs[$key]->sm = $config->sm;
					$subs[$key]->md = $config->md;
					$subs[$key]->lg = $config->lg;
				}
				$entry->subs = $subs;
				Shop::Smarty()->assign('entry',$entry);
				$code = Shop::Smarty()->fetch('snackys_content/grid.tpl');
				break;
			case 4:
				//Bild, Daten laden
				$data = json_decode($entry->cContent);
				if($data)
				{
					$entry->cLink = $data->cLink;
					$entry->cBild = $data->cBild;
					$entry->cCaption = $data->cCaption;
					$entry->cAltTag = !empty($data->cAltTag) ? $data->cAltTag : $data->cCaption;
					Shop::Smarty()->assign('entry',$entry);
					$code = Shop::Smarty()->fetch('snackys_content/image.tpl');
				}
				break;
			case 5:
				//Accordeon, also auch dessen Subs laden!
				$subs = Shop::Container()->getDB()->query('SELECT * FROM `km_snackys_content` WHERE '.$where.' AND `parent`='.$entry->id.' ORDER BY nSort ASC,cName ASC',2);
				foreach($subs as $key=>$sub)
				{
					if($this->checkSnackysContent($sub))
						$subs[$key]->rendered = $this->renderSnackysContent($sub,$where);
					
					$config = json_decode($sub->nConfig);
					$subs[$key]->cNamePanel = $config->cNamePanel;
					
				}
				$entry->subs = $subs;
				Shop::Smarty()->assign('entry',$entry);
				$code = Shop::Smarty()->fetch('snackys_content/accordeon.tpl');
				break;
			default:
				if($Einstellungen['optimize_content'] == 'Y')
					$entry->cContent = $this->optimize($entry->cContent);
				Shop::Smarty()->assign('entry',$entry);
				//$code = '<div class="snackys-content '.$entry->cClass.'">'.$entry->cContent.'</div>';
				$code = Shop::Smarty()->fetch('snackys_content/content.tpl');
				break;
		}
		
		//Jetzt ausgeben
		return $code;
	}
	
	public function getSliderPerDevice($params, $smarty)
	{
	}
	public function loadCSS($params, $smarty)
	{
        $reader    = new XMLReader();
        $tplXML    = $reader->getXML($this->template->getTemplate(), false);
        $parentXML = ($tplXML === null || empty($tplXML->Parent)) ? null : $reader->getXML((string)$tplXML->Parent);
		
		$cssArr = array();
		if(is_array($params['css1'])) $cssArr = array_merge($cssArr,$params['css1']);
		if(is_array($params['css2'])) $cssArr = array_merge($cssArr,$params['css2']);
		if(is_array($params['css3'])) $cssArr = array_merge($cssArr,$params['css3']);
		elseif(!empty($params['css3'])) $cssArr[] = $params['css3'];
		
		
		$cTemplateDir = $smarty->get_template_vars('currentTemplateDir');
		$parentTemplateDir = $smarty->get_template_vars('parentTemplateDir');
		$Einstellungen = $smarty->get_template_vars('Einstellungen'); //template.theme.theme_default
		$Einstellungen2 = $smarty->get_template_vars('snackyConfig'); //template.theme.theme_default
		
		//Falls Childtemplate, zuerst vom Vater laden
		if($parentXML && (!isset($tplXML->CSSPageTypes) || !isset($tplXML->CSSPageTypes->attributes()->override)))
		{
			foreach($parentXML->CSSPageTypes as $o)
				foreach($o as $css)
					if($css->attributes()->PageType == $params['cPageType'] || $css->attributes()->PageType == 'all')
					{
						$path = str_replace('##theme##',$Einstellungen['template']['theme']['theme_default'],$css->attributes()->Path);
						if(substr($path,0,1) != '/') $path = '/'.$cTemplateDir.$path;
						$cssArr[] = $path;
					}
		}
		
		//Jetzt noch vom aktuellen Template laden!	
		if(!empty($tplXML->CSSPageTypes))		
		{
			foreach($tplXML->CSSPageTypes as $o)
				foreach($o as $css)
					if($css->attributes()->PageType == $params['cPageType'] || $css->attributes()->PageType == 'all')
					{
						$path = str_replace('##theme##',$Einstellungen['template']['theme']['theme_default'],$css->attributes()->Path);
						if(substr($path,0,1) != '/') $path = '/'.$cTemplateDir.$path;
						$cssArr[] = $path;
					}
		}
		
		//Jetzt noch die CSS Werte ersetzen! (ggf. später durch die Templateinstellungen ersetzen??
		$cssConfig = array();
		foreach($Einstellungen2 as $key => $val)
		{
			if(substr($key,0,4) == 'css_')
			$cssConfig[substr($key,4)] = $val;
		}
		
		//Ist es eine Listen oder Detailseite? => GGF CSS Eigenschaften überschreiben!
		$nSeitenTyp = $smarty->get_template_vars('nSeitenTyp');
		$zusatzConfigs = array();
		$zusatzConfigsCheck = '';
		if($nSeitenTyp === 1)
		{
			$x = $smarty->get_template_vars('Artikel');
			if($x && isset($x->FunktionsAttribute))
				$zusatzConfigs = $x->FunktionsAttribute;
		} elseif($nSeitenTyp === 2) {
			$x = $smarty->get_template_vars('AktuelleKategorie');
			if($x && isset($x->categoryFunctionAttributes))
				$zusatzConfigs = $x->categoryFunctionAttributes;
		}
		if(count($zusatzConfigs) > 0)
		{
			foreach($zusatzConfigs as $key => $val)
				if(substr($key,0,4) == 'css_')
				{
					foreach($cssConfig as $key2 => $val2)
						if(strtolower($key2) == strtolower(substr($key,4)))
						{
							$cssConfig[$key2] = $val;
						}
					$zusatzConfigsCheck = substr($key,4).'###'.$val.'|';
				}
		}
		
		

		//Ausgabe!
		$minified = '';
		$zusatzConfigsCheck = ($zusatzConfigsCheck == '') ? '' : '_'.crc32($zusatzConfigsCheck);
		$cssFile = PFAD_ROOT.'templates/Snackys/temp/main_inline_css_'.crc32(implode(';',$cssArr)).$zusatzConfigsCheck.'.css';
		
		if(file_exists($cssFile) && !isset($_REQUEST['rebuildCache']))
			$minified = file_get_contents($cssFile);
		
		if($Einstellungen2['debug_mode'] == 'Y') $minified = '';
		
		
		if($minified == '')
		{
			$css = '';
			foreach($cssArr as $file)
			{
				if(file_exists(PFAD_ROOT.'/'.$file))
					$css .= file_get_contents(PFAD_ROOT.'/'.$file);
			}
				
			//Add Snackys CSS Content
			$customCSS = Shop::Container()->getDB()->select('km_snackys_csshtml', 'nKey', 'css');
			$css .= $customCSS->nValue;

			$colors = array();
			foreach($cssConfig as $var => $cfg)
				$colors['@'.$var] = $cfg;
			//foreach($Einstellungen['template']['pdListing'] as $var => $cfg)
			//	$colors['@'.$var] = $cfg;
			
			$css = str_replace(array_keys($colors), $colors, $css);
			if(!class_exists('CSSmin'))
				$minified = $css;
			else
			{
				$minify = new CSSmin;
				$minified = @$minify->run($css);
			}
			file_put_contents($cssFile, $minified);
		}
		$css = '<style id="maincss">'.$minified.'</style>';
		echo $css;
	}
	public function getSizeBySrc($params, $smarty)
	{
		$params['src'] = str_replace(URL_SHOP,PFAD_ROOT,$params['src']);
		if(strpos($params['src'],'//') !== false)
			$params['src'] = str_replace('//','/', $params['src']);
		
		list($width, $height, $type, $attr) = getimagesize($params['src']);
		if(!$width) return;
		
		if(isset($params['cAssign']))
			$smarty->assign($params['cAssign'], array('width' => $width, 'height' => $height, 'padding' => ($height / $width * 100)));
		return ;
	}
	public function getZahlungsarten($params, $smarty)
	{
		if(isset($params['cAssign']))
		{
			$customerGroupID = Frontend::getCustomer()->getGroupID();
			if (!$customerGroupID) {
				$customerGroupID = Frontend::getCustomerGroup()->getID();
			}
			$payments = Shop::Container()->getDB()->query("SELECT DISTINCT tzahlungsart.* FROM tzahlungsart 
				INNER JOIN tversandartzahlungsart ON tzahlungsart.kZahlungsart=tversandartzahlungsart.kZahlungsart
				WHERE tzahlungsart.nActive = 1 AND tzahlungsart.nNutzbar = 1
				 AND (tzahlungsart.cKundengruppen IS NULL OR tzahlungsart.cKundengruppen=''
                    OR FIND_IN_SET('.$customerGroupID.', REPLACE(tzahlungsart.cKundengruppen, ';', ',')) > 0)
				",2);
			$smarty->assign($params['cAssign'],$payments);
		}
		
		return false;
	}
	public function checkCopyfree($string)
	{
		$parts = parse_url(URL_SHOP);
		$parts['host'] = str_replace("www.","",$parts['host']);
		$check = md5($parts['host']).crc32($parts['host']);
		if(empty($check)) $check = 'XcUxIycWrh5GYSL5vg22WaluNKCiZgDN';
		return $string!=$check;
	}
	public function optimize($str)
	{

		//Iframes nachladen
		$muster = '/\<iframe(.*)>/i';
		$str = preg_replace_callback($muster,function($match){
			if(strpos($match[0],'data-src'))
				return $match[0];
			else
			{
				$snackyConfig = Shop::Smarty()->get_template_vars('snackyConfig');
				return str_replace('src=','class="lazyload" data-src=',$match[0]);
			}
		},$str);
		
		//Bilder nachladen
		$muster = '/\<img(.*)>/i';
		$str = preg_replace_callback($muster,function($match){
			if(strpos($match[0],'data-src'))
				return $match[0];
			else
			{
				$snackyConfig = Shop::Smarty()->get_template_vars('snackyConfig');
				return str_replace('src=','class="lazyload" data-src=',$match[0]);
			}
		},$str);
		
		return $str;
	}
	
	public function entferneFehlerzeichen($string)
	{
		return mb_convert_encoding($string, 'UTF-8', 'UTF-8');
	}
	public function getLink($params, $smarty)
	{
		if(!isset($params['nLinkart'])) return;
		
		try {
			$link = Shop::Container()->getLinkService()->getSpecialPage($params['nLinkart']);
			if(!$link) return;
		} catch (\JTL\Link\SpecialPageNotFoundException $e) { return false; }
		
		$smarty->assign($params['cAssign'],$link);
		
		return ;
	}

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return array|void
     */
    public function getProductList($params, $smarty)
    {
        $limit                 = (int)($params['nLimit'] ?? 10);
        $sort                  = (int)($params['nSortierung'] ?? 0);
        $assignTo              = (isset($params['cAssign']) && \strlen($params['cAssign']) > 0)
            ? $params['cAssign']
            : 'oCustomArtikel_arr';
        $characteristicFilters = isset($params['cMerkmalFilter'])
            ? ProductFilter::initCharacteristicFilter(\explode(';', $params['cMerkmalFilter']))
            : [];
        $searchFilters         = isset($params['cSuchFilter'])
            ? ProductFilter::initSearchFilter(\explode(';', $params['cSuchFilter']))
            : [];
        $params                = [
            'kKategorie'             => $params['kKategorie'] ?? null,
            'kHersteller'            => $params['kHersteller'] ?? null,
            'kArtikel'               => $params['kArtikel'] ?? null,
            'kVariKindArtikel'       => $params['kVariKindArtikel'] ?? null,
            'kSeite'                 => $params['kSeite'] ?? null,
            'kSuchanfrage'           => $params['kSuchanfrage'] ?? null,
            'kMerkmalWert'           => $params['kMerkmalWert'] ?? null,
            'kSuchspecial'           => $params['kSuchspecial'] ?? null,
            'kKategorieFilter'       => $params['kKategorieFilter'] ?? null,
            'kHerstellerFilter'      => $params['kHerstellerFilter'] ?? null,
            'nBewertungSterneFilter' => $params['nBewertungSterneFilter'] ?? null,
            'cPreisspannenFilter'    => $params['cPreisspannenFilter'] ?? '',
            'kSuchspecialFilter'     => $params['kSuchspecialFilter'] ?? null,
            'nSortierung'            => $sort,
            'MerkmalFilter_arr'      => $characteristicFilters,
            'SuchFilter_arr'         => $searchFilters,
            'nArtikelProSeite'       => $params['nArtikelProSeite'] ?? null,
            'cSuche'                 => $params['cSuche'] ?? null,
            'seite'                  => $params['seite'] ?? null
        ];
        if ($params['kArtikel'] !== null) {
            $products = [];
            if (!\is_array($params['kArtikel'])) {
                $params['kArtikel'] = [$params['kArtikel']];
            }
            foreach ($params['kArtikel'] as $productID) {
                $product    = new Artikel();
                $products[] = $product->fuelleArtikel($productID, Artikel::getDefaultOptions());
            }
        } else {
            $products = (new ProductFilter(
                Config::getDefault(),
                $this->db,
                $this->cache
            ))
                ->initStates($params)
                ->generateSearchResults(null, true, $limit)
                ->getProducts()
                ->all();
        }

        $smarty->assign($assignTo, $products);

        if (isset($params['bReturn'])) {
            return $products;
        }
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return bool|string
     */
    public function getStaticRoute($params, $smarty)
    {
        if (isset($params['id'])) {
            $full   = !isset($params['full']) || $params['full'] === true;
            $secure = isset($params['secure']) && $params['secure'] === true;
            $url    = Shop::Container()->getLinkService()->getStaticRoute($params['id'], $full, $secure);
            $qp     = isset($params['params'])
                ? (array)$params['params']
                : [];

            if (\count($qp) > 0) {
                $url .= (\parse_url($url, \PHP_URL_QUERY) ? '&' : '?') . \http_build_query($qp, '', '&');
            }
            if (isset($params['assign'])) {
                $smarty->assign($params['assign'], $url);
            } else {
                return $url;
            }
        }

        return false;
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return array|void
     */
    public function getManufacturers($params, $smarty)
    {
        $manufacturers = Manufacturer::getInstance()->getManufacturers();
        if (isset($params['assign'])) {
            $smarty->assign($params['assign'], $manufacturers);

            return;
        }

        return $manufacturers;
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return array|void
     */
    public function getBoxesByPosition($params, $smarty)
    {
        if (isset($params['position'])) {
            $data  = Shop::Container()->getBoxService()->boxes;
            $boxes = $data[$params['position']] ?? [];
            if (isset($params['assign'])) {
                $smarty->assign($params['assign'], $boxes);
            } else {
                return $boxes;
            }
        }
    }

    /**
     * @param array                         $params - categoryId mainCategoryId. 0 for first level categories
     * @param Smarty_Internal_Data $smarty
     * @return array|void
     */
    public function getCategoryArray($params, $smarty)
    {
        $id = isset($params['categoryId']) ? (int)$params['categoryId'] : 0;
        if ($id === 0) {
            $categories = Category::getInstance();
            $list       = $categories->combinedGetAll();
        } else {
            $categories = new KategorieListe();
            $list       = $categories->getAllCategoriesOnLevel($id);
        }

        if (isset($params['categoryBoxNumber']) && (int)$params['categoryBoxNumber'] > 0) {
            $list2 = [];
            foreach ($list as $key => $item) {
                if (isset($item->categoryFunctionAttributes[\KAT_ATTRIBUT_KATEGORIEBOX])
                    && $item->categoryFunctionAttributes[\KAT_ATTRIBUT_KATEGORIEBOX] == $params['categoryBoxNumber']
                ) {
                    $list2[$key] = $item;
                }
            }
            $list = $list2;
        }

        if (isset($params['assign'])) {
            $smarty->assign($params['assign'], $list);

            return;
        }

        return $list;
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return array|void
     */
    public function getCategoryParents($params, $smarty)
    {
        $id         = isset($params['categoryId']) ? (int)$params['categoryId'] : 0;
        $categories = new KategorieListe();
        $list       = $categories->getOpenCategories(new Kategorie($id));

        \array_shift($list);
        $list = \array_reverse($list);

        if (isset($params['assign'])) {
            $smarty->assign($params['assign'], $list);

            return;
        }

        return $list;
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return string
     */
    public function getImgTag($params, $smarty): string
    {
        if (empty($params['src'])) {
            return '';
        }
        $size = $this->getImageSize($params['src']);

        $url   = $params['src'];
        $id    = isset($params['id']) ? ' id="' . $params['id'] . '"' : '';
        $alt   = isset($params['alt']) ? ' alt="' . $this->truncate($params['alt'], 75) . '"' : '';
        $title = isset($params['title']) ? ' title="' . $this->truncate($params['title'], 75) . '"' : '';
        $class = isset($params['class']) ? ' class="' . $this->truncate($params['class'], 75) . '"' : '';
        if (\strpos($url, 'http') !== 0) {
            $url = Shop::getImageBaseURL() . \ltrim($url, '/');
        }
        if ($size !== null && $size->size->width > 0 && $size->size->height > 0) {
            return '<img src="' . $url . '" width="' . $size->size->width . '" height="' .
                $size->size->height . '"' . $id . $alt . $title . $class . ' />';
        }

        return '<img src="' . $url . '"' . $id . $alt . $title . $class . ' />';
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     */
    public function hasBoxes($params, $smarty): void
    {
        $boxData = $smarty->getTemplateVars('boxes');
        $smarty->assign($params['assign'], !empty($boxData[$params['position']]));
    }

    /**
     * @param string $text
     * @param int    $length
     * @return string
     */
    public function truncate($text, $length)
    {
        if (\strlen($text) > $length) {
            $text = \substr($text, 0, $length);
            $text = \substr($text, 0, \strrpos($text, ' '));
            $text .= '...';
        }

        return $text;
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return mixed|string
     */
    public function getLocalizedPrice($params, $smarty)
    {
        $surcharge                     = new \stdClass();
        $surcharge->cAufpreisLocalized = '';
        $surcharge->cPreisInklAufpreis = '';

        if ((float)$params['fAufpreisNetto'] != 0) {
            $fAufpreisNetto = (float)$params['fAufpreisNetto'];
            $fVKNetto       = (float)$params['fVKNetto'];
            $kSteuerklasse  = (int)$params['kSteuerklasse'];
            $fVPEWert       = (float)$params['fVPEWert'];
            $cVPEEinheit    = $params['cVPEEinheit'];
            $funcAttributes = $params['FunktionsAttribute'];
            $precision      = (isset($funcAttributes[\FKT_ATTRIBUT_GRUNDPREISGENAUIGKEIT])
                && (int)$funcAttributes[\FKT_ATTRIBUT_GRUNDPREISGENAUIGKEIT] > 0)
                ? (int)$funcAttributes[\FKT_ATTRIBUT_GRUNDPREISGENAUIGKEIT]
                : 2;

            if ((int)$params['nNettoPreise'] === 1) {
                $surcharge->cAufpreisLocalized = Preise::getLocalizedPriceString($fAufpreisNetto);
                $surcharge->cPreisInklAufpreis = Preise::getLocalizedPriceString($fAufpreisNetto + $fVKNetto);
                $surcharge->cAufpreisLocalized = ($fAufpreisNetto > 0)
                    ? ('+ ' . $surcharge->cAufpreisLocalized)
                    : \str_replace('-', '- ', $surcharge->cAufpreisLocalized);

                if ($fVPEWert > 0) {
                    $surcharge->cPreisVPEWertAufpreis     = Preise::getLocalizedPriceString(
                            $fAufpreisNetto / $fVPEWert,
                            Frontend::getCurrency()->getCode(),
                            true,
                            $precision
                        ) . ' ' . Shop::Lang()->get('vpePer') . ' ' . $cVPEEinheit;
                    $surcharge->cPreisVPEWertInklAufpreis = Preise::getLocalizedPriceString(
                            ($fAufpreisNetto + $fVKNetto) / $fVPEWert,
                            Frontend::getCurrency()->getCode(),
                            true,
                            $precision
                        ) . ' ' . Shop::Lang()->get('vpePer') . ' ' . $cVPEEinheit;

                    $surcharge->cAufpreisLocalized .= ', ' . $surcharge->cPreisVPEWertAufpreis;
                    $surcharge->cPreisInklAufpreis .= ', ' . $surcharge->cPreisVPEWertInklAufpreis;
                }
            } else {
                $surcharge->cAufpreisLocalized = Preise::getLocalizedPriceString(
                    Tax::getGross($fAufpreisNetto, $_SESSION['Steuersatz'][$kSteuerklasse], 4)
                );
                $surcharge->cPreisInklAufpreis = Preise::getLocalizedPriceString(
                    Tax::getGross($fAufpreisNetto + $fVKNetto, $_SESSION['Steuersatz'][$kSteuerklasse], 4)
                );
                $surcharge->cAufpreisLocalized = ($fAufpreisNetto > 0)
                    ? ('+ ' . $surcharge->cAufpreisLocalized)
                    : \str_replace('-', '- ', $surcharge->cAufpreisLocalized);

                if ($fVPEWert > 0) {
                    $surcharge->cPreisVPEWertAufpreis     = Preise::getLocalizedPriceString(
                            Tax::getGross($fAufpreisNetto / $fVPEWert, $_SESSION['Steuersatz'][$kSteuerklasse]),
                            Frontend::getCurrency()->getCode(),
                            true,
                            $precision
                        ) . ' ' . Shop::Lang()->get('vpePer') . ' ' . $cVPEEinheit;
                    $surcharge->cPreisVPEWertInklAufpreis = Preise::getLocalizedPriceString(
                            Tax::getGross(
                                ($fAufpreisNetto + $fVKNetto) / $fVPEWert,
                                $_SESSION['Steuersatz'][$kSteuerklasse]
                            ),
                            Frontend::getCurrency()->getCode(),
                            true,
                            $precision
                        ) . ' ' . Shop::Lang()->get('vpePer') . ' ' . $cVPEEinheit;

                    $surcharge->cAufpreisLocalized .= ', ' . $surcharge->cPreisVPEWertAufpreis;
                    $surcharge->cPreisInklAufpreis .= ', ' . $surcharge->cPreisVPEWertInklAufpreis;
                }
            }
        }

        return (isset($params['bAufpreise']) && (int)$params['bAufpreise'] > 0)
            ? $surcharge->cAufpreisLocalized
            : $surcharge->cPreisInklAufpreis;
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     */
    public function hasCheckBoxForLocation($params, $smarty): void
    {
        $smarty->assign(
            $params['bReturn'],
            \count((new CheckBox())->getCheckBoxFrontend((int)$params['nAnzeigeOrt'], 0, true, true)) > 0
        );
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     */
    public function getCheckBoxForLocation($params, $smarty): void
    {
        $langID     = Shop::getLanguageID();
        $cid        = 'cb_' . (int)$params['nAnzeigeOrt'] . '_' . $langID;
        $checkBoxes = Shop::has($cid)
            ? Shop::get($cid)
            : (new CheckBox())->getCheckBoxFrontend((int)$params['nAnzeigeOrt'], 0, true, true);
        if (\count($checkBoxes) > 0) {
            foreach ($checkBoxes as $checkBox) {
                $url                     = $checkBox->kLink > 0
                    ? $checkBox->getLink()->getURL()
                    : '';
                $error                   = isset($params['cPlausi_arr'][$checkBox->cID]);
                $checkBox->isActive      = isset($params['cPost_arr'][$checkBox->cID]);
                $checkBox->cName         = $checkBox->oCheckBoxSprache_arr[$langID]->cText ?? '';
                $checkBox->cLinkURL      = $url;
                $checkBox->cLinkURLFull  = $url;
                $checkBox->cBeschreibung = !empty($checkBox->oCheckBoxSprache_arr[$langID]->cBeschreibung)
                    ? $checkBox->oCheckBoxSprache_arr[$langID]->cBeschreibung
                    : '';
                $checkBox->cErrormsg     = $error
                    ? Shop::Lang()->get('pleasyAccept', 'account data')
                    : '';
            }
            Shop::set($cid, $checkBoxes);
            if (isset($params['assign'])) {
                $smarty->assign($params['assign'], $checkBoxes);
            }
        }
    }

    /**
     * @param array $params
     * @return string
     */
    public function aaURLEncode($params): string
    {
        $reset  = (int)($params['nReset'] ?? 0) === 1;
        $url    = $_SERVER['REQUEST_URI'];
        $params = ['&aaParams', '?aaParams', '&aaReset', '?aaReset'];
        $exists = false;
        foreach ($params as $param) {
            $exists = \strpos($url, $param);
            if ($exists !== false) {
                $url = \substr($url, 0, $exists);
                break;
            }
            $exists = false;
        }
        if ($exists !== false) {
            $url = \substr($url, 0, $exists);
        }
        if (isset($params['bUrlOnly']) && (int)$params['bUrlOnly'] === 1) {
            return $url;
        }
        $paramString = '';
        unset($params['nReset']);
        if (\is_array($params) && \count($params) > 0) {
            foreach ($params as $key => $param) {
                $paramString .= $key . '=' . $param . ';';
            }
        }

        $sep = (\strpos($url, '?') === false) ? '?' : '&';

        return $url . $sep . ($reset ? 'aaReset=' : 'aaParams=') . \base64_encode($paramString);
    }

    /**
     * @param array                         $params - ['type'] Templatename of link, ['assign'] array name to assign
     * @param Smarty_Internal_Data $smarty
     */
    public function getNavigation($params, $smarty): void
    {
        if (!isset($params['assign'])) {
            return;
        }
        $identifier = $params['linkgroupIdentifier'];
        $linkGroup  = null;
        if (\strlen($identifier) > 0) {
            $linkGroups = Shop::Container()->getLinkService()->getVisibleLinkGroups();
            $linkGroup  = $linkGroups->getLinkgroupByTemplate($identifier);
        }
        if ($linkGroup !== null && $linkGroup->isAvailableInLanguage(Shop::getLanguageID())) {
            $smarty->assign($params['assign'], $this->buildNavigationSubs($linkGroup));
        }
    }

    /**
     * @param LinkGroupInterface $linkGroup
     * @param int                $parentID
     * @return Collection
     */
    public function buildNavigationSubs(LinkGroupInterface $linkGroup, $parentID = 0): Collection
    {
        $parentID = (int)$parentID;
        $links    = new Collection();
        if ($linkGroup->getTemplate() === 'hidden' || $linkGroup->getName() === 'hidden') {
            return $links;
        }
        foreach ($linkGroup->getLinks() as $link) {
            /** @var Link $link */
            if ($link->getParent() !== $parentID) {
                continue;
            }
            $link->setChildLinks($this->buildNavigationSubs($linkGroup, $link->getID()));
            $link->setIsActive($link->getIsActive() || (Shop::$kLink > 0 && Shop::$kLink === $link->getID()));
            $links->push($link);
        }

        return $links;
    }

    /**
     * @param array $params
     * @return string|object|null
     */
    public function prepareImageDetails($params)
    {
        if (!isset($params['item'])) {
            return null;
        }

        $result = [
            'xs' => $this->getImageSize($params['item']->cPfadMini),
            'sm' => $this->getImageSize($params['item']->cPfadKlein),
            'md' => $this->getImageSize($params['item']->cPfadNormal),
            'lg' => $this->getImageSize($params['item']->cPfadGross)
        ];

        if (isset($params['type'])) {
            $type = $params['type'];
            if (isset($result[$type])) {
                $result = $result[$type];
            }
        }
        $imageBaseURL = Shop::getImageBaseURL();
        foreach ($result as $size => $data) {
            if (isset($data->src) && \strpos($data->src, 'http') !== 0) {
                $data->src = $imageBaseURL . $data->src;
            }
        }
        $result = (object)$result;

        return (isset($params['json']) && $params['json'])
            ? \json_encode($result, \JSON_FORCE_OBJECT)
            : $result;
    }

    /**
     * @param string $image
     * @return object|null
     */
    public function getImageSize($image)
    {
        $path = \strpos($image, \PFAD_BILDER) === 0
            ? PFAD_ROOT . $image
            : $image;
        if (\file_exists($path)) {
            [$width, $height, $type] = \getimagesize($path);
        } else {
            $req = Product::toRequest($path);

            if (!\is_object($req)) {
                return null;
            }

            $settings = Image::getSettings();
            $refImage = $req->getRaw();
            if ($refImage === null) {
                return null;
            }

            [$width, $height, $type] = \getimagesize($refImage);

            $size       = $settings['size'][$req->getSizeType()];
            $max_width  = $size['width'];
            $max_height = $size['height'];
            $old_width  = $width;
            $old_height = $height;

            $scale  = \min($max_width / $old_width, $max_height / $old_height);
            $width  = \ceil($scale * $old_width);
            $height = \ceil($scale * $old_height);
        }

        return (object)[
            'src'  => $image,
            'size' => (object)[
                'width'  => $width,
                'height' => $height
            ],
            'type' => $type
        ];
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return mixed
     */
    public function getCMSContent($params, $smarty)
    {
        if (isset($params['kLink']) && (int)$params['kLink'] > 0) {
            $linkID  = (int)$params['kLink'];
            $link    = Shop::Container()->getLinkService()->getLinkByID($linkID);
            $content = $link !== null ? $link->getContent() : null;
            if (isset($params['assign'])) {
                $smarty->assign($params['assign'], $content);
            } else {
                return $content;
            }
        }

        return null;
    }

    /**
     * @param array                         $params - variationen, maxVariationCount, maxWerteCount
     * @param Smarty_Internal_Data $smarty
     * @return int|null|bool
     * 0: no listable variations
     * 1: normal listable variations
     * 2: only child listable variations
     */
    public function hasOnlyListableVariations($params, $smarty)
    {
        if (!isset($params['artikel']->Variationen)) {
            if (isset($params['assign'])) {
                $smarty->assign($params['assign'], 0);

                return null;
            }

            return 0;
        }

        $maxVariationCount = isset($params['maxVariationCount']) ? (int)$params['maxVariationCount'] : 1;
        $maxWerteCount     = isset($params['maxWerteCount']) ? (int)$params['maxWerteCount'] : 3;
        $variationCheck    = function ($Variationen, $maxVariationCount, $maxWerteCount) {
            $result   = true;
            $varCount = \is_array($Variationen) ? \count($Variationen) : 0;

            if ($varCount > 0 && $varCount <= $maxVariationCount) {
                foreach ($Variationen as $oVariation) {
                    if ($oVariation->cTyp !== 'SELECTBOX'
                        && (!\in_array($oVariation->cTyp, ['TEXTSWATCHES', 'IMGSWATCHES', 'RADIO'], true)
                            || \count($oVariation->Werte) > $maxWerteCount)) {
                        $result = false;
                        break;
                    }
                }
            } else {
                $result = false;
            }

            return $result;
        };

        $result = $variationCheck($params['artikel']->Variationen, $maxVariationCount, $maxWerteCount) ? 1 : 0;
        if ($result === 0 && $params['artikel']->kVaterArtikel > 0) {
            // Hat das Kind evtl. mehr Variationen als der Vater?
            $result = $variationCheck($params['artikel']->oVariationenNurKind_arr, $maxVariationCount, $maxWerteCount)
                ? 2
                : 0;
        }

        if (isset($params['assign'])) {
            $smarty->assign($params['assign'], $result);

            return null;
        }

        return $result;
    }

    /**
     * Input: ['ger' => 'Titel', 'eng' => 'Title']
     *
     * @param string|array $mixed
     * @param string|null  $to - locale
     * @return null|string
     */
    public function getTranslation($mixed, $to = null): ?string
    {
        $to = $to ?: Shop::getLanguageCode();

        if ($this->hasTranslation($mixed, $to)) {
            return \is_string($mixed) ? $mixed : $mixed[$to];
        }

        return null;
    }

    /**
     * Has any translation
     *
     * @param string|array $mixed
     * @param string|null  $to - locale
     * @return bool
     */
    public function hasTranslation($mixed, $to = null): bool
    {
        $to = $to ?: Shop::getLanguageCode();

        return \is_string($mixed) ?: isset($mixed[$to]);
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return string
     */
    public function captchaMarkup($params, $smarty): string
    {
        if (isset($params['getBody']) && $params['getBody']) {
            return Shop::Container()->getCaptchaService()->getBodyMarkup($smarty);
        }

        return Shop::Container()->getCaptchaService()->getHeadMarkup($smarty);
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return array|null|void
     */
    public function getStates($params, $smarty)
    {
        $regions = Staat::getRegions($params['cIso']);
        if (!isset($params['assign'])) {
            return $regions;
        }
        $smarty->assign($params['assign'], $regions);
    }

    /**
     * @param $params
     * @return int
     */
    public function getDecimalLength($params): int
    {
        return \max(\strlen(\strrchr(\str_replace(',', '.', $params['quantity']), '.')) - 1, 0);
    }

    /**
     * prepares a string optimized for SEO
     * @param String $optStr
     * @return String SEO optimized String
     */
    public function seofy($optStr = ''): string
    {
        return \str_replace('/', '-', Seo::sanitizeSeoSlug($optStr));
    }

    /**
     * @param array                         $params
     * @param Smarty_Internal_Data $smarty
     * @return void
     */
    public function getUploaderLang($params, $smarty): void
    {
        $availableLocales = [
            'ar', 'az', 'bg', 'ca', 'cr', 'cs', 'da', 'de', 'el', 'es', 'et', 'fa', 'fi', 'fr', 'gl', 'he', 'hu', 'id',
            'it', 'ja', 'ka', 'kr', 'kz', 'lt', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sv', 'th', 'tr', 'uk',
            'uz', 'vi', 'zh'
        ];

        $smarty->assign($params['assign'], \in_array($params['iso'], $availableLocales, true) ? $params['iso'] : 'LANG');
    }
	
    /**
     * @param array                         $params
     * @param Smarty_Internal_Data			$smarty
     * @return void
     */
    public function getCountry($params, $smarty): void
    {
        $smarty->assign($params['assign'], Shop::Container()->getCountryService()->getCountry($params['iso']));
    }
}
