{extends file="{$parent_template_path}/productdetails/details.tpl"}
{block name="product-pagination"}

{/block}

{block name="buyform-block"}
    <form id="buy_form" method="post" action="{$Artikel->cURLFull}" class="jtl-validate mb-lg">
        {$jtl_token}
        <div class="row product-primary" id="product-offer">
            <div class="product-gallery col-12 col-sm-7">
                {include file="snippets/zonen.tpl" id="opc_before_gallery"}
                {include file="productdetails/image.tpl"}
                {include file="snippets/zonen.tpl" id="after_gallery"}
            </div>
            <div class="product-info col-12 col-sm-5">
                <div class="product-info-inner">
                    {block name="productdetails-info"}
                        {block name="productdetails-details-info"}

                            {block name="product-headline-block"}
                                <div class="product-headline">
                                    {include file="snippets/zonen.tpl" id="opc_before_headline"}
                                    <h1 class="product-title">{$Artikel->cName}</h1>
                                </div>
                            {/block}

                            {block name="productdetails-info-essential-wrapper"}
                                {if ($Artikel->Bewertungen->oBewertungGesamt->nAnzahl > 0) || isset($Artikel->cArtNr) || ($Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen === 'Y')}
                                    <div class="info-essential row mb-xs">

                                        <hr>
                                        <div class="col-6">
                                            {block name="productdetails-info-essential"}
                                                <ul class="blanklist nav nav-sm">
                                                    {block name="productdetails-info-artnr-wrapper"}
                                                        {if isset($Artikel->cArtNr)}
                                                            <li class="product-sku nav-it">
                                                                <span>{lang key="sortProductno"}: {$Artikel->cArtNr}</span>
                                                            </li>
                                                        {/if}
                                                    {/block}

                                                    {block name="productdetails-info-mhd-wrapper"}
                                                        {if isset($Artikel->dMHD) && isset($Artikel->dMHD_de)}
                                                            <li title="{lang key='productMHDTool'}" class="best-before nav-it">
                                                                <span>{lang key="productMHD"}: {$Artikel->dMHD_de}</span>
                                                            </li>
                                                        {/if}
                                                    {/block}

                                                    {block name="productdetails-info-barcode-wrapper"}
                                                        {if !empty($Artikel->cBarcode) && ($Einstellungen.artikeldetails.gtin_display === 'details' || $Einstellungen.artikeldetails.gtin_display === 'always')}
                                                            <li class="nav-it">
                                                                <span>{lang key='ean'}: {$Artikel->cBarcode}</span>
                                                            </li>
                                                        {/if}
                                                    {/block}

                                                    {block name="productdetails-info-isbn-wrapper"}
                                                        {if !empty($Artikel->cISBN) && ($Einstellungen.artikeldetails.isbn_display === 'D' || $Einstellungen.artikeldetails.isbn_display === 'DL')}
                                                            <li class="nav-it">
                                                                <span>{lang key='isbn'}: {$Artikel->cISBN}</span>
                                                            </li>
                                                        {/if}
                                                    {/block}

                                                    {block name="productdetails-info-category-wrapper"}
                                                        {assign var=i_kat value=($Brotnavi|@count)-2}
                                                        {if $Einstellungen.artikeldetails.artikeldetails_kategorie_anzeigen === 'Y' && isset($Brotnavi[$i_kat])}
                                                            <li class="product-category word-break nav-it">
                                                                {lang key="category" section="global"}: <a href="{$Brotnavi[$i_kat]->getURLFull()}">{$Brotnavi[$i_kat]->getName()}</a>
                                                            </li>
                                                        {/if}
                                                    {/block}

                                                    {block name="productdetails-info-gefahrgut-wrapper"}
                                                        {if !empty($Artikel->cUNNummer) && !empty($Artikel->cGefahrnr) && ($Einstellungen.artikeldetails.adr_hazard_display === 'D' || $Einstellungen.artikeldetails.adr_hazard_display === 'DL')}
                                                            <li class="nav-it">
                                                                {lang key='adrHazardSign'}:
                                                                <div class="adr-table text-center">
                                                                    <span class="block first">{$Artikel->cGefahrnr}</span>
                                                                    <span class="block">{$Artikel->cUNNummer}</span>
                                                                </div>
                                                            </li>
                                                        {/if}
                                                    {/block}
                                                    {if ($Einstellungen.bewertung.bewertung_anzeigen === 'Y' && $Artikel->Bewertungen->oBewertungGesamt->nAnzahl > 0)}
                                                        {block name="productdetails-info-rating-wrapper"}
                                                            <li class="rating-wrapper nav-it dpflex-a-center">
                                                                <span class="icon-wt">{lang key="rating" section="global"}:</span>
                                                                <a id="jump-to-votes-tab" class="hidden-print"{if $Einstellungen.artikeldetails.artikeldetails_tabs_nutzen == 'N' || $isMobile} data-toggle="collapse" href="#tab-votes" role="button"{else} href="{$Artikel->cURLFull}#tab-votes" {/if}>
                                                                    {include file='productdetails/rating.tpl' stars=$Artikel->Bewertungen->oBewertungGesamt->fDurchschnitt total=$Artikel->Bewertungen->oBewertungGesamt->nAnzahl}
                                                                </a>
                                                            </li>
                                                        {/block}
                                                    {/if}
                                                </ul>
                                            {/block}
                                        </div>
                                        <div class="col-6">
                                            <ul class="blanklist nav nav-sm">
                                                {block name="productdetails-info-manufacturer-wrapper"}
                                                    {if $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen !== 'N' && isset($Artikel->cHersteller)}
                                                        <li class="nav-it dpflex-a-center">
                                                            {block name="product-info-manufacturer"}
                                                                {*<span class="block first icon-wt">{lang key='manufacturer' section='productDetails'}: </span>*}
                                                                {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen === 'Y'}
                                                                    <a href="{if !empty($Artikel->cHerstellerHomepage)}{$Artikel->cHerstellerHomepage}{else}{$Artikel->cHerstellerSeo}{/if}" title="{$Artikel->cHersteller|escape:'html'}" class="dpflex-a-c">
                                                                {else}
                                                                    <span class="dpflex-a-c">
                                                                {/if}
                                                                {if ($Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen === 'B' || $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen === 'BT') && !empty($Artikel->cHerstellerBildURLKlein)}
                                                                    <span class="img-ct icon icon-wt icon-xl contain">
                                                    {image lazy=true webp=true src=$Artikel->cHerstellerBildURLKlein alt=$Artikel->cHersteller|escape:'html'}
                                                    </span>
                                                                {/if}
                                                                {if $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen !== 'B'}
                                                                    <span>{$Artikel->cHersteller}</span>
                                                                {/if}
                                                                {if $Einstellungen.artikeldetails.artikel_weitere_artikel_hersteller_anzeigen === 'Y'}
                                                                    </a>
                                                                {else}
                                                                    </span>
                                                                {/if}
                                                            {/block}
                                                        </li>
                                                    {/if}
                                                {/block}
                                            </ul>
                                        </div>
                                    </div>
                                {/if}

                                <div class="modal fade" id="copy-info" tabindex="-1" role="dialog" aria-labelledby="pp-question_on_item-label" aria-hidden="true">
                                    <div class="modal-dialog" role="document" data-dismiss="modal">
                                        <div class="modal-content">
                                            <div class="modal-header"><h5 class="modal-title" id="pp-question_on_item-label">{lang key="copy_hinweis_header" section="custom"}</h5>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                </button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="panel-wrap">
                                                    {lang key="copy_hinweis" section="custom"}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            {/block}

                            {block name="productdetails-info-description-wrapper"}
                                {if $Einstellungen.artikeldetails.artikeldetails_kurzbeschreibung_anzeigen === 'Y' && $Artikel->cKurzBeschreibung}
                                    {block name="productdetails-info-description"}
                                        {include file="snippets/zonen.tpl" id="opc_before_short_desc"}
                                        <div class="shortdesc mb-xs">
                                            {if $snackyConfig.optimize_artikel == "Y"}{$Artikel->cKurzBeschreibung|optimize}{else}{$Artikel->cKurzBeschreibung}{/if}
                                        </div>
                                        {include file="snippets/zonen.tpl" id="opc_after_short_desc"}
                                    {/block}
                                {/if}
                            {/block}

                            <div class="product-offer">
                                <hr>
                                {block name="productdetails-info-hidden"}
                                    <input type="submit" name="inWarenkorb" value="1" class="hidden" />
                                    {if $Artikel->kArtikelVariKombi > 0}
                                        <input type="hidden" name="aK" value="{$Artikel->kArtikelVariKombi}" />
                                    {/if}
                                    {if isset($Artikel->kVariKindArtikel)}
                                        <input type="hidden" name="VariKindArtikel" value="{$Artikel->kVariKindArtikel}" />
                                    {/if}
                                    {if isset($smarty.get.ek)}
                                        <input type="hidden" name="ek" value="{$smarty.get.ek|intval}" />
                                    {/if}
                                    <input type="hidden" id="AktuellerkArtikel" class="current_article" name="a" value="{$Artikel->kArtikel}" />
                                    <input type="hidden" name="wke" value="1" />
                                    <input type="hidden" name="show" value="1" />
                                    <input type="hidden" name="kKundengruppe" value="{$smarty.session.Kundengruppe->getID()}" />
                                    <input type="hidden" name="kSprache" value="{$smarty.session.kSprache}" />
                                {/block}
                                {block name="productdetails-info-variation"}
                                    <!-- VARIATIONEN -->
                                    {include file="productdetails/variation.tpl" simple=$Artikel->isSimpleVariation showMatrix=$showMatrix}
                                {/block}
                                {*UPLOADS product-specific files, e.g. for customization*}
                                {* block name='productdetails-details-include-uploads'}
                                    {include file="snippets/uploads.tpl" tplscope='product'}
                                {/block *}

                                {* --- Staffelpreise? --- *}
                                {if !empty($Artikel->staffelPreis_arr)}
                                    {block name="details-staffelpreise-wrapper"}
                                        <div class="bulk-price">
                                        {block name="detail-bulk-price"}
                                            <table class="table table-condensed table-hover">
                                                <thead>
                                                <tr>
                                                    <th class="text-right">
                                                        {lang key='fromDifferential' section='productOverview'}
                                                    </th>
                                                    <th class="text-right">{lang key='pricePerUnit' section='productDetails'}{if $Artikel->cEinheit} / {$Artikel->cEinheit}{/if}
                                                        {if isset($Artikel->cMasseinheitName) && isset($Artikel->fMassMenge) && $Artikel->fMassMenge > 0 && $Artikel->cTeilbar !== 'Y' && ($Artikel->fAbnahmeintervall == 0 || $Artikel->fAbnahmeintervall == 1) && isset($Artikel->cMassMenge)}
                                                            ({$Artikel->cMassMenge} {$Artikel->cMasseinheitName})
                                                        {/if}
                                                    </th>
                                                    {if !empty($Artikel->staffelPreis_arr[0].cBasePriceLocalized)}
                                                        <th class="text-right">
                                                            {lang key='basePrice'}
                                                        </th>
                                                    {/if}
                                                </tr>
                                                </thead>
                                                <tbody>
                                                {foreach $Artikel->staffelPreis_arr as $bulkPrice}
                                                    {if $bulkPrice.nAnzahl > 0}
                                                        <tr class="bulk-price-{$bulkPrice.nAnzahl}">
                                                            <td class="text-right">{$bulkPrice.nAnzahl}</td>
                                                            <td class="text-right bulk-price">
                                                                {$bulkPrice.cPreisLocalized[$NettoPreise]} <span class="footnote-reference">*</span>
                                                            </td>
                                                            {if !empty($bulkPrice.cBasePriceLocalized)}
                                                                <td class="text-right bulk-base-price">
                                                                    {$bulkPrice.cBasePriceLocalized[$NettoPreise]}
                                                                </td>
                                                            {/if}
                                                        </tr>
                                                    {/if}
                                                {/foreach}
                                                </tbody>
                                            </table>
                                        {/block}
                                        </div>{* /bulk-price *}
                                    {/block}
                                {/if}
                                {block name='productdetails-details-include-uploads'}
                                    {include file="snippets/uploads.tpl" tplscope='product'}
                                {/block}
                                {block name="km-sonderpreis-bis"}
                                    {if !empty($Artikel->dSonderpreisEnde_de) && $Artikel->dSonderpreisEnde_de|date_format:"%y%m%d" >= $smarty.now|date_format:"%y%m%d"  && $Artikel->dSonderpreisStart_de|date_format:"%y%m%d" <= $smarty.now|date_format:"%y%m%d"}
                                        {if $snackyConfig.specialpriceDate == "C"}
                                            {assign var="uid" value="art_c_{$Artikel->kArtikel}_{1|mt_rand:20}"}
                                            <div id="{$uid}" class="sale-wp mb-sm mt-sm text-center panel">
                                                <div class="mb-xs h4">{lang key="sonderpreisBisDetail" section="custom"}</div>
                                                <div class="dpflex-j-c">
                                                    <div class="ct-wp days">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='days'}</div>
                                                    </div>
                                                    <div class="ct-wp hours">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='hours'}</div>
                                                    </div>
                                                    <div class="ct-wp minutes">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='minutes'}</div>
                                                    </div>
                                                    <div class="ct-wp seconds">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='seconds'}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        {inline_script}<script>
                                            $(() => {
                                                let until = new Date("{$Artikel->dSonderpreisEnde_de|date_format:"Y-m-d"}T23:59:59");
                                                let countDownDate = until.getTime();
                                                let timeout = setInterval(update, 1000);

                                                update();
                                                $(window).trigger('resize');

                                                function update()
                                                {
                                                    let now      = new Date().getTime();
                                                    let distance = countDownDate - now;
                                                    let days     = Math.floor(distance / (1000 * 60 * 60 * 24));
                                                    let hours    = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                                    let minutes  = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                                    let seconds  = Math.floor((distance % (1000 * 60)) / 1000);

                                                    if (distance <= 0) {
                                                        clearInterval(timeout);
                                                        days    = 0;
                                                        hours   = 0;
                                                        minutes = 0;
                                                        seconds = 0;
                                                        $("#{$uid}").hide();
                                                        $(window).trigger('resize');
                                                    }

                                                    $("#{$uid} .days .ct-it").html(days);
                                                    $("#{$uid} .hours .ct-it").html(hours);
                                                    $("#{$uid} .minutes .ct-it").html(minutes);
                                                    $("#{$uid} .seconds .ct-it").html(seconds);
                                                }
                                            });
                                        </script>{/inline_script}
                                        {elseif $snackyConfig.specialpriceDate == "D"}
                                            <div class="mb-sm mt-sm panel text-center">
                                                <div class="h4 m0">
                                                    {lang key="sonderpreisBisDetail" section="custom"} {$Artikel->dSonderpreisEnde_de|date_format:"{$snackyConfig.deliveryDateFormat}"}
                                                </div>
                                            </div>
                                        {/if}
                                    {/if}
                                {/block}
                                {block name="km-verfuegbar-ab"}
                                    {if $Artikel->nErscheinendesProdukt}
                                        {if $snackyConfig.availableDate == "C"}
                                            {assign var="uid" value="aval-ct"}
                                            <div id="{$uid}" class="sale-wp mb-sm mt-sm text-center panel">
                                                <div class="mb-xs h4">{lang key="productAvailableIn" section="custom"}</div>
                                                <div class="dpflex-j-c">
                                                    <div class="ct-wp days">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='days'}</div>
                                                    </div>
                                                    <div class="ct-wp hours">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='hours'}</div>
                                                    </div>
                                                    <div class="ct-wp minutes">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='minutes'}</div>
                                                    </div>
                                                    <div class="ct-wp seconds">
                                                        <div class="ct-it">0</div>
                                                        <div class="ct-un">{lang key='seconds'}</div>
                                                    </div>
                                                </div>
                                                {if $Einstellungen.global.global_erscheinende_kaeuflich === 'Y' && $Artikel->inWarenkorbLegbar == 1}
                                                    <div class="mt-xs text-muted">{lang key="preorderPossible" section="global"}</div>
                                                {/if}
                                            </div>
                                        {inline_script}<script>
                                            $(() => {
                                                let until = new Date("{$Artikel->Erscheinungsdatum_de|date_format:"Y-m-d"}T00:00:00");
                                                let countDownDate = until.getTime();
                                                let timeout = setInterval(update, 1000);

                                                update();
                                                $(window).trigger('resize');

                                                function update()
                                                {
                                                    let now      = new Date().getTime();
                                                    let distance = countDownDate - now;
                                                    let days     = Math.floor(distance / (1000 * 60 * 60 * 24));
                                                    let hours    = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                                    let minutes  = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                                    let seconds  = Math.floor((distance % (1000 * 60)) / 1000);

                                                    if (distance <= 0) {
                                                        clearInterval(timeout);
                                                        days    = 0;
                                                        hours   = 0;
                                                        minutes = 0;
                                                        seconds = 0;
                                                        $("#{$uid}").hide();
                                                        $(window).trigger('resize');
                                                    }

                                                    $("#{$uid} .days .ct-it").html(days);
                                                    $("#{$uid} .hours .ct-it").html(hours);
                                                    $("#{$uid} .minutes .ct-it").html(minutes);
                                                    $("#{$uid} .seconds .ct-it").html(seconds);
                                                }
                                            });
                                        </script>{/inline_script}
                                        {elseif $snackyConfig.availableDate == "D"}
                                            <div class="mb-sm mt-sm panel text-center">
                                                <div class="h4 m0">
                                                    {lang key="productAvailableFrom" section="global"}: {$Artikel->Erscheinungsdatum_de}
                                                </div>
                                                {if $Einstellungen.global.global_erscheinende_kaeuflich === 'Y' && $Artikel->inWarenkorbLegbar == 1}
                                                    <div class="mt-xxs text-muted">{lang key="preorderPossible" section="global"}</div>
                                                {/if}
                                            </div>
                                        {/if}
                                    {/if}
                                {/block}
                                {block name="details-buy-wrapper"}
                                    <div class="buy-wrapper row">
                                        <div class="col-12 col-md-6{if $Artikel->bHasKonfig} no-pop-tg{elseif $snackyConfig.css_maxPageWidth >= 1600} col-xl-6{/if} as-fs">
                                            {if $Artikel->SieSparenX->nProzent == 0}
                                            {else}
                                                {*if $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige == 2 || isset($Einstellungen.artikeluebersicht) && $Einstellungen.artikeluebersicht.artikeluebersicht_rabattanzeige == 4*}
                                                <div class="discount">
                                                    {lang key="youSave" section="productDetails"}
                                                    <span class="percent">{$Artikel->SieSparenX->nProzent}%</span>
                                                </div>
                                            {/if}
                                            {block name="productdetails-info-price-exkl"}
                                                {if !($Artikel->Preise->fVKNetto == 0 && isset($Artikel->FunktionsAttribute[$smarty.const.FKT_ATTRIBUT_VOUCHER_FLEX]))}
                                                    {include file="productdetails/price_netto.tpl" Artikel=$Artikel tplscope="detail"}
                                                {/if}
                                            {/block}
                                        </div>
                                        <div class="col-12 col-md-6{if $Artikel->bHasKonfig} no-pop-tg{elseif $snackyConfig.css_maxPageWidth >= 1600} col-xl-6{/if} as-fs">

                                            {if $snackyConfig.oldPricePlace !== '1'}
                                                <div class="instead-of old-price">

                                                    {if !empty($Artikel->Preise->alterVKLocalized[$NettoPreise])}
                                                        <del class="value">{$Artikel->Preise->alterVKLocalized[$NettoPreise]}</del>
                                                    {else}

                                                    {/if}
                                                </div>
                                            {/if}

                                            {block name="productdetails-info-price"}
                                                {if !($Artikel->Preise->fVKNetto == 0 && isset($Artikel->FunktionsAttribute[$smarty.const.FKT_ATTRIBUT_VOUCHER_FLEX]))}
                                                    {include file="productdetails/price.tpl" Artikel=$Artikel tplscope="detail"}
                                                {/if}
                                            {/block}
                                        </div>
                                        <div class="col-12 col-md-6{if $Artikel->bHasKonfig}{elseif $snackyConfig.css_maxPageWidth >= 1600} col-xl-6{/if} hotstock-col">

                                            {if $isMobile}
                                            {else}
                                                <div class="wrp-gg">
                                                    <a class="btn-gg" href="{lang key="ggBtnLink" section="custom"}" alt="{lang key="ggBtnText" section="custom"}">
                                    <span class="img-ct icon ic-md">
                                        <svg>
                                            <use xlink:href="{$ShopURL}/templates/Turbozentrum/img/icons/munny-icon.svg?v=1.0.0#icon-munny"></use>
                                        </svg>
                                    </span>
                                                        <span class="btn-gg-text">
                                        {lang key="ggBtnText" section="custom"}
                                    </span>
                                                    </a>
                                                </div>
                                            {/if}

                                            {block name="details-wenig-bestand-wrapper"}
                                                {if $snackyConfig.hotStock > 0 && $Artikel->cLagerBeachten === 'Y' && $Artikel->cLagerKleinerNull === 'N' && $Artikel->fLagerbestand <= $snackyConfig.hotStock && $Artikel->fLagerbestand > 0}
                                                    <div class="mb-xxs">
                                                        <div class="alert alert-hotstock m0 text-center"><strong>{lang key="hotStock" section="custom" printf=$Artikel->fLagerbestand}</strong></div>
                                                    </div>
                                                {/if}
                                            {/block}
                                            {block name="productdetails-info-stock"}
                                                {include file="productdetails/stock.tpl" tplscope="detail"}
                                            {/block}
                                        </div>
                                        <div class="col-12 col-md-6{if $Artikel->bHasKonfig}{elseif $snackyConfig.css_maxPageWidth >= 1600} col-xl-6{/if} buy-col">

                                            {if $isMobile}
                                                <div class="wrp-gg">
                                                    <a class="btn-gg" href="{lang key="ggBtnLink" section="custom"}"
                                                       alt="{lang key="ggBtnText" section="custom"}">
                                                <span class="img-ct icon ic-md">
                                                    <svg>
                                                        <use
                                                                xlink:href="{$ShopURL}/templates/Turbozentrum/img/icons/munny-icon.svg?v=1.0.0#icon-munny">
                                                        </use>
                                                    </svg>
                                                </span>
                                                        <span class="btn-gg-text">
                                                    {lang key="ggBtnText" section="custom"}
                                                </span>
                                                    </a>
                                                </div>
                                            {else}
                                            {/if}

                                            {block name="details-buy-buttons-wrapper"}
                                                {block name="details-buy-config-wrapper"}
                                                    {assign var="configRequired" value=false}
                                                    {if $Artikel->bHasKonfig}
                                                        {block name="productdetails-config"}
                                                            <div id="product-configurator">
                                                                <div class="product-config top10">
                                                                    {*KONFIGURATOR*}
                                                                    {include file="productdetails/config.tpl"}
                                                                </div>
                                                            </div>
                                                        {/block}
                                                    {/if}
                                                {/block}
                                                {block name="details-buy-submit-wrapper"}
                                                    {*WARENKORB anzeigen wenn keine variationen mehr auf lager sind?!*}
                                                    {include file="productdetails/basket.tpl"}
                                                {/block}
                                            {/block}
                                            {block name="detail-notification-wrapper"}
                                                {if ($verfuegbarkeitsBenachrichtigung == 1 || $verfuegbarkeitsBenachrichtigung == 2 || $verfuegbarkeitsBenachrichtigung == 3)}
                                                    {if $verfuegbarkeitsBenachrichtigung == 1}
                                                        <a id="goToNotification" href="#tab-availabilityNotification" class="btn btn btn-primary btn-block btn-lg" title="{lang key='requestNotification'}">
                                                            {lang key='requestNotification'}
                                                        </a>
                                                    {else}
                                                        <button type="button" id="n{$kArtikel}" class="btn popup-dep notification btn btn-primary btn-block btn-lg" title="{lang key='requestNotification'}" data-toggle="modal" data-target="#pp-availability_notification">
                                                            {lang key='requestNotification'}
                                                        </button>
                                                    {/if}
                                                {elseif $Artikel->Lageranzeige->nStatus == '0'}
                                                    <div class="alert alert-danger text-center m0">{lang key='soldout'}</div>
                                                {/if}
                                            {/block}
                                            <div class="add-pays text-center dpflex">
                                                <div class="paypal"></div>
                                                <div class="amazon"></div>
                                            </div>
                                            <div class="payplan"></div>
                                        </div>
                                    </div>
                                {/block}
                                {if isset($varKombiJSON) && $varKombiJSON!= ''}
                                    <script id="varKombiArr" type="application/json">{$varKombiJSON}</script>
                                {/if}
                            </div>
                        {/block}{* productdetails-detail-info *}

                    {/block}{* productdetails-info *}
                    {include file="snippets/zonen.tpl" id="after_product_info" title="after_product_info"}


                    {block name="details-matrix"}
                        {include file="productdetails/matrix.tpl"}
                    {/block}
                </div>
                <div class="col-12">
                    {block name="details-buy-actions-wrapper"}
                        {if !($Artikel->nIstVater && $Artikel->kVaterArtikel == 0)}
                            <div class="hidden">
                                {include file="productdetails/actions.tpl"}
                            </div>
                        {/if}
                    {/block}
                    {block name="details-buy-actions-label-wrapper"}
                        {if !($Artikel->nIstVater && $Artikel->kVaterArtikel == 0)}
                            {include file="productdetails/actions-labels.tpl"}
                        {/if}
                    {/block}
                </div>
                <div class="col-12 chalt">
                    {* Günstigere Alternativen/Hochwertigere Alternativen*}
                    {block name="details-buy-cheap-alt-container"}
                        {if !empty($Artikel->FunktionsAttribute['alternative_hochwertiger'])}
                            {get_product_alternate cArtNr=$Artikel->FunktionsAttribute['alternative_hochwertiger'] cAssign="cross_alternative_hochwertiger"}
                            {lang key="alternative_hochwertiger" section="custom" assign="cross_alternative_headline_hocherwertiger"}
                            {*$cross_alternative_hochwertiger|@print_r*}
                            <div class="chalt-wrap">
                                <div class="chalt-head">
                                    {lang key="alt-head-text" section="custom"}
                                </div>
                                <div class="chalt-inner">
                                    {foreach name="cross_alternative_hochwertiger" from=$cross_alternative_hochwertiger item='product'}
                                        <div class="col-12 p-w">
                                            {include file='productlist/item_slider.tpl' Artikel=$product tplscope=$tplscope class=''}
                                        </div>
                                    {/foreach}
                                </div>
                            </div>
                        {/if}
                        {if !empty($Artikel->FunktionsAttribute['alternative_guenstiger'])}
                            {get_product_alternate cArtNr=$Artikel->FunktionsAttribute['alternative_guenstiger'] cAssign="cross_alternative_guenstiger"}
                            {lang key="alternative_guenstiger" section="custom" assign="cross_alternative_headline_guenstiger"}
                            {*$cross_alternative_guenstiger|@print_r*}

                            <div class="chalt-wrap">
                                <div class="chalt-head">
                                    {lang key="chalt-head-text" section="custom"}
                                </div>
                                <div class="chalt-inner">
                                    {foreach name="cross_alternative_hochwertiger" from=$cross_alternative_guenstiger item='product'}
                                        <div class="col-12 p-w">
                                            {include file='productlist/item_slider.tpl' Artikel=$product tplscope=$tplscope class=''}
                                        </div>
                                    {/foreach}
                                </div>
                            </div>
                        {/if}

                    {/block}
                </div>
            </div></div>{* /col *}

        </div>{* /row *}
    </form>
{/block}
