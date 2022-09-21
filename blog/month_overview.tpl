{block name='blog-month-overview'}
<h1>{lang key="newsMonthOverview" section="news"}</h1>

{if $noarchiv}
    {lang key="noNewsArchiv" section="news"}.
{else}
    <div id="newsMonth">
        <h4 class="title"><span>{$cName}</span></h4>
        {*<div class="content">
           <p>{lang key="newsArchivDesc" section="global"}</p>
         </div>*}
    </div>
    {if !empty($oNews_arr)}
        <div id="news-c">
			{foreach $oNews_arr as $oNews}
                <div class="newsBox">
                    <div class="newsTopTitle">
                        <h2 class="newsHeadline"><a href="{$oNews->cURL}">{$oNews->cBetreff}</a></h2>
                    </div>
                    <div class="newsTime">{$oNews->dErstellt_de} |
                        <a href="{$oNews->cURL}#comments" title="{lang key="readComments" section="news"}">
                            {$oNews->nNewsKommentarAnzahl} {if $oNews->nNewsKommentarAnzahl == 1}{lang key="newsComment" section="news"}{else}{lang key="newsComments" section="news"}{/if}
                        </a>
                    </div>
                    <div class="newsArchivText">
                        {if $oNews->cVorschauText|count_characters > 0}
                            {$oNews->cVorschauText}
                            <div class="flt_right">
                                <a class="news-more" href="{$oNews->cURLFull}">{lang key='moreLink' section='news'}</a>
                            </div>
                            <div class="clearer"></div>
                        {elseif $oNews->cText|count_characters > 200}
                            {$oNews->cText|truncate:200}
							<a class="news-more-link" href="{$oNews->cURLFull}">{lang key='moreLink' section='news'}</a>
                        {else}
                            {$oNews->cText}
                        {/if}
                    </div>

                </div>
            {/foreach}
        </div>
    {/if}

    {if !empty($oNewsNavi_arr)}
        <div id="newsNavi">
            <h4 class="title">{lang key="newsNavi" section="global"}</h4>
            <ul>
                {foreach $oNewsNavi_arr as $oNewsNavi}
                    <li><a href="{$oNewsNavi->cURL}"><strong>{$oNewsNavi->cName}</strong></a>
                        <span class="smallfontMerkmale">({$oNewsNavi->nAnzahl})</span></li>
                {/foreach}
            </ul>
        </div>
    {/if}
    <p>
        <strong>&laquo;</strong>
        <a href="javascript:history.back()">{lang key="newsletterhistoryback" section="newsletter"}</a>
    </p>
{/if}
{/block}