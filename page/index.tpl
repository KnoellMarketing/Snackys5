{block name='page-index'}
    {include file="snippets/zonen.tpl" id="start-under-slider" title="Startseite: Unter dem Slider"}
    {if !empty($cFehler)}
        <div class="alert alert-danger">{$cFehler}</div>
    {/if}
    {block name="index-productwizard-wrapper"}
        {include file="productwizard/index.tpl"}
    {/block}
    {block name="index-article-sliders"}
        {include file="snippets/zonen.tpl" id="opc_before_boxes"}
        {if isset($StartseiteBoxen) && $StartseiteBoxen|count > 0}
            {assign var='moreLink' value=null}
            {assign var='moreTitle' value=null}
            {foreach $StartseiteBoxen as $Box}
                {if isset($Box->Artikel->elemente) && count($Box->Artikel->elemente)>0 && isset($Box->cURL)}
                    {if $Box->name === 'TopAngebot'}
                        {lang key="topOffer" section="global" assign='title'}
                        {lang key='showAllTopOffers' section='global' assign='moreTitle'}
                    {elseif $Box->name === 'Sonderangebote'}
                        {lang key="specialOffer" section="global" assign='title'}
                        {lang key='showAllSpecialOffers' section='global' assign='moreTitle'}
                    {elseif $Box->name === 'NeuImSortiment'}
                        {lang key="newProducts" section="global" assign='title'}
                        {lang key='showAllNewProducts' section='global' assign='moreTitle'}
                    {elseif $Box->name === 'Bestseller'}
                        {lang key="bestsellers" section="global" assign='title'}
                        {lang key='showAllBestsellers' section='global' assign='moreTitle'}
                    {/if}
                    {assign var='moreLink' value=$Box->cURL}
                    {include file='snippets/product_slider.tpl' productlist=$Box->Artikel->elemente title=$title hideOverlays=true moreLink=$moreLink moreTitle=$moreTitle}
                {/if}
            {/foreach}
        {/if}
    {/block}
    {block name="index-manuslider-wrapper"}
        {if $snackyConfig.manSlider == 0 && $manufacturers|@count > 0}
        <section class="panel-default panel-slider mb-spacer" id="man-sl">
            <div class="panel-heading">
                <div class="panel-title dpflex-a-center dpflex-j-between mb-spacer mb-xs">
                   <span class="h2 m0 block">{lang key="manufacturers" section="global"}</span>
                    <div class="right">
                        {if !$isMobile}
                            <div class="ar-ct btn-group{if $manufacturers|@count > 8} show-xl{/if}{if $manufacturers|@count > 6} show-lg{/if}{if $manufacturers|@count > 4} show-md{/if}{if $manufacturers|@count > 4} show-sm{/if}{if $manufacturers|@count > 3} show-xs{/if}{if $manufacturers|@count > 2} show-xxs{/if}">
                                <span class="sl-ar sl-pr btn inactive">
                                    <span class="ar ar-l"></span>
                                </span>
                                <span class="sl-ar sl-nx btn">
                                    <span class="ar ar-r"></span>
                                </span>
                            </div>
                        {/if}
                        {assign var='linkKeyHersteller' value=\JTL\Shop::Container()->getLinkService()->getSpecialPageID(LINKTYP_HERSTELLER, false)|default:0}
                        {assign var='linkSEOHersteller' value=\JTL\Shop::Container()->getLinkService()->getLinkByID($linkKeyHersteller)|default:null}
                        {if $linkSEOHersteller !== null && !empty($linkSEOHersteller->getName())}
                            <a class="btn btn-primary" href="{$linkSEOHersteller->getURL()}" title="{$linkSEOHersteller->getName()}" aria-label="{$linkSEOHersteller->getName()}">
                                <span class="hidden-xs">
                                {lang key="showAll" section="global"}
                                </span>
                                <span class="visible-xs">
                                    <span class="ar ar-r"></span>
                                </span>
                            </a>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="panel-body">
                {if $isMobile || (isset($tplscope) && $tplscope === 'box')}
                <div class="row ar-ct-m">
                    <div class="col-12 ar-ct{if $manufacturers|@count > 8} show-xl{/if}{if $manufacturers|@count > 6} show-lg{/if}{if $manufacturers|@count > 4} show-md{/if}{if $manufacturers|@count > 4} show-sm{/if}{if $manufacturers|@count > 3} show-xs{/if}{if $manufacturers|@count > 2} show-xxs{/if}">
                        <span class="sl-ar sl-pr btn inactive">
                            <span class="ar ar-l"></span>
                        </span>
                        <span class="sl-ar sl-nx btn">
                            <span class="ar ar-r"></span>
                        </span>
                    </div>
                </div>
                {/if}
                <div class="row p-sl no-scrollbar dpflex-nowrap">
                    {foreach name=hersteller from=$manufacturers item=hst}
                    {if !empty($hst->getImage())}
                        <div class="col-lg-2 p-w">
                            <div class="p-c">
                                <div class="img-w text-center">
                                    <a href="{$hst->getURL()}" class="img-ct">
                                        {image fluid=true lazy=true webp=true
                                        src=$hst->getImage(\JTL\Media\Image::SIZE_MD)
                                        alt=$hst->getName()|escape:'html'
                                        class="image"}
                                    </a>
                                </div>
                                {if !$isMobile}
                                    <a href="{$hst->getURL()}" class="caption text-center block">
                                        <strong>{$hst->getName()}</strong>
                                	</a>
                                {/if}
                            </div>
                        </div>
                    {/if}
                    {/foreach}
                </div>
            </div>
        </section>{* /panel *}
        {/if}
    {/block}
    {block name="index-additional"}
        {if isset($oNews_arr) && $oNews_arr|count > 0}
        {include file="snippets/zonen.tpl" id="opc_before_news"}
            <section class="mb-spacer" id="news-overview">
                <div class="dpflex-a-center dpflex-j-between mb-spacer mb-small">
                    <span class="block h2 m0">{lang key="news" section="news"}</span>
                    <a href="{get_static_route id='news.php'}" title="{lang key="news" section="news"}" class="btn btn-primary">
                        {lang key="showAll" section="global"}
                    </a>
                 </div>
                <div class="row row-multi" id="newslist">
                    {foreach $oNews_arr as $newsItem}
                        <div class="col-6 col-sm-6 col-md-4 col-lg-4{if $snackyConfig.css_maxPageWidth >= 1600} col-xl-3{/if}">
                        {include file="blog/preview.tpl"}
                        </div>
                    {/foreach}
                </div>
            </section>
        {/if}
    {/block}
{/block}