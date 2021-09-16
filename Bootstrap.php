<?php declare(strict_types=1);

namespace Template\Snackys;

use JTL\License\Struct\ExsLicense;
use JTL\Shop;
use JTL\Template\Bootstrapper;
use scc\DefaultComponentRegistrator;
use scc\Renderer;
use Smarty;
use JTL\DB\DbInterface;

/**
 * Class Bootstrap
 * @package Template\Snackys
 */
class Bootstrap extends Bootstrapper
{
    /**
     * @inheritdoc
     */
    public function boot(): void
    {
        parent::boot();
        $this->registerPlugins();
		$this->loadSnackysConfigs();
		
    }

    protected function loadSnackysConfigs(): void
    {
		$configs = $this->getDB()->query('SELECT * FROM km_snackys_config',2);
		$return = array();
		foreach($configs as $conf)
			$return[$conf->nKey] = $conf->nValue;
			
		$this->getSmarty()->assign('snackyConfig',$return);
		
		//$additionalHeadTags
		$headtags = Shop::Container()->getDB()->select('km_snackys_csshtml', 'nKey', 'head');
		$this->getSmarty()->assign('additionalHeadTags',$headtags->nValue);
	}

    protected function registerPlugins(): void
    {
        $smarty = $this->getSmarty();
        if ($smarty === null) {
            // this will never happen but it calms the IDE down
            return;
        }
        $plugins = new Plugins($this->getDB(), $this->getCache(), $this->getTemplate());
        $scc     = new DefaultComponentRegistrator(new Renderer($smarty));
        $scc->registerComponents();

        if (isset($_GET['scc-demo']) && Shop::isAdmin()) {
            $smarty->display('demo.tpl');
            die();
        }

	   
		//Snackys
		$smarty->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getSliderPerDevice',[$plugins, 'getSliderPerDevice'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'loadCSS', [$plugins,'loadCSS'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getSizeBySrc', [$plugins,'getSizeBySrc'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getZahlungsarten', [$plugins,'getZahlungsarten'])
			->registerPlugin(Smarty::PLUGIN_MODIFIER, 'checkCopyfree', [$plugins,'checkCopyfree'])
			->registerPlugin(Smarty::PLUGIN_MODIFIER, 'optimize', [$plugins,'optimize'])
			->registerPlugin(Smarty::PLUGIN_MODIFIER, 'entferneFehlerzeichen', [$plugins,'entferneFehlerzeichen'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'snackys_content', [$plugins,'snackys_content'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getLink', [$plugins,'getLink'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getActiveOPCItems', [$plugins,'getActiveOPCItems'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getDeliveryDate', [$plugins,'getDeliveryDate']);

		//Alte Evo Funktionen, ggf. mal ersetzen??
		$smarty->registerPlugin(Smarty::PLUGIN_FUNCTION, 'load_boxes',[$plugins, 'load_boxes'])
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'load_boxes_raw', [$plugins,'load_boxes_raw'])
			//->registerPlugin(Smarty::PLUGIN_FUNCTION, 'image', [$plugins,'get_img_tag'])	=> das gibt es jetzt in SCC, daher einmal checken!
			->registerPlugin(Smarty::PLUGIN_FUNCTION, 'ts_data', [$plugins,'get_trustedshops_data']);
	   
	   //Standards
        $smarty->registerPlugin(Smarty::PLUGIN_FUNCTION, 'gibPreisStringLocalizedSmarty', [$plugins, 'getLocalizedPrice'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getBoxesByPosition', [$plugins, 'getBoxesByPosition'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'has_boxes', [$plugins, 'hasBoxes'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'imageTag', [$plugins, 'getImgTag'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getCheckBoxForLocation', [$plugins, 'getCheckBoxForLocation'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'hasCheckBoxForLocation', [$plugins, 'hasCheckBoxForLocation'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'aaURLEncode', [$plugins, 'aaURLEncode'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_navigation', [$plugins, 'getNavigation'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_category_array', [$plugins, 'getCategoryArray'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_category_parents', [$plugins, 'getCategoryParents'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'prepare_image_details', [$plugins, 'prepareImageDetails'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_manufacturers', [$plugins, 'getManufacturers'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_cms_content', [$plugins, 'getCMSContent'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_static_route', [$plugins, 'getStaticRoute'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'hasOnlyListableVariations', [$plugins, 'hasOnlyListableVariations'])
            ->registerPlugin(Smarty::PLUGIN_MODIFIER, 'has_trans', [$plugins, 'hasTranslation'])
            ->registerPlugin(Smarty::PLUGIN_MODIFIER, 'trans', [$plugins, 'getTranslation'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'get_product_list', [$plugins, 'getProductList'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'captchaMarkup', [$plugins, 'captchaMarkup'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getStates', [$plugins, 'getStates'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getDecimalLength', [$plugins, 'getDecimalLength'])
            ->registerPlugin(Smarty::PLUGIN_MODIFIER, 'seofy', [$plugins, 'seofy'])
            ->registerPlugin(Smarty::PLUGIN_FUNCTION, 'getUploaderLang', [$plugins, 'getUploaderLang']);
    }

    /**
     * @inheritDoc
     */
    public function licenseExpired(ExsLicense $license): void
    {
		//Im Frontend eine Ausgabe integrieren, dass die Lizenz abgelaufen ist!
		
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

    /**
     * @inheritdoc
     */
    public function installed(): void
    {
        parent::installed();
    }

    /**
     * @inheritDoc
     */
    public function enabled(): void
    {
        parent::enabled();
    }

    /**
     * @inheritDoc
     */
    public function disabled(): void
    {
        parent::enabled();
    }

    /**
     * @inheritdoc
     */
    public function updated($oldVersion, $newVersion): void
    {
    }

    /**
     * @inheritdoc
     */
    public function uninstalled(bool $deleteData = true): void
    {
        parent::uninstalled($deleteData);
    }
}
