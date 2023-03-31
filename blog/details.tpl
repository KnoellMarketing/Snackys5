{block name='blog-details'}
{include file='snippets/extension.tpl'}

{if !empty($cNewsErr)}
    <div class="alert alert-danger">{lang key='newsRestricted' section='news'}</div>
{else}
    <article>
        <div id="nw-ct">
            <h1 class="text-center">
                {$oNewsArchiv->getTitle()}
            </h1>
            {block name='blog-details-author'}
				<div class="author-meta text-center">
					{if empty($newsItem->getDateValidFrom())}
						{assign var=dDate value=$newsItem->getDateCreated()->format('d.m.Y')}
					{else}
						{assign var=dDate value=$newsItem->getDateValidFrom()->format('d.m.Y')}
					{/if}
					<span class="date">{$dDate}</span>
					{if isset($Einstellungen.news.news_kategorie_unternewsanzeigen) && $Einstellungen.news.news_kategorie_unternewsanzeigen === 'Y' && !empty($oNewsKategorie_arr)}
						{block name='blog-details-sub-news'}
							<span class="news-categorylist">
								{if $newsItem->getAuthor() === null}/{/if}
								{foreach $oNewsKategorie_arr as $newsCategory}
									{link itemprop="articleSection"
										href="{$newsCategory->getURL()}"
										title="{$newsCategory->getDescription()|strip_tags|escape:'html'|truncate:60}"
										class="{if !$newsCategory@last}mr-1{/if} d-inline-block"
									}
										{$newsCategory->getName()}
									{/link}
								{/foreach}
							</span>
						{/block}
					{/if}

					{block name='blog-details-comments-link'}
						{if $Einstellungen.news.news_kommentare_nutzen === 'Y' && $newsItem->getCommentCount() > 0}
						/
						<a class="dpflex-a-c df-inl" href="#comments" title="{lang key='readComments' section='news'}">
							<span class="img-ct icon mr-xxs">
								<svg>
								  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-comment"></use>
								</svg>
							</span>
							<span>
								{$newsItem->getCommentCount()}
								{if $newsItem->getChildCommentsCount()  && $Einstellungen.news.news_kommentare_anzahl_antwort_kommentare_anzeigen === 'Y'}
									({$newsItem->getChildCommentsCount()})
								{/if}
							</span>
						</a>
						{/if}
					{/block}
				</div>
			{/block}
            {if $newsItem->getPreviewImage() !== ''}
                {block name='blog-details-image'}
                    <div class="img-ct rt4x3 mt-sm mb-sm">
                    {include file='snippets/image.tpl'
                        item=$newsItem
                        square=false
                        center=true
                        class="blog-details-image"
                        alt="{$newsItem->getTitle()|escape:'quotes'} - {$newsItem->getMetaTitle()|escape:'quotes'}"}
                    </div>
                {/block}
            {/if}
            <div class="mb-spacer mb-small">
                {if $snackyConfig.optimize_news == "Y"}{$oNewsArchiv->getContent()|optimize}{else}{$oNewsArchiv->getContent()}{/if}
            </div>

            {if isset($Einstellungen.news.news_kategorie_unternewsanzeigen) && $Einstellungen.news.news_kategorie_unternewsanzeigen === 'Y' && !empty($oNewsKategorie_arr)}
                <div class="newscats mb-spacer mb-small">
                    {foreach $oNewsKategorie_arr as $newsCategory}
                        <a href="{$newsCategory->getURL()}" title="{$newsCategory->getDescription()|strip_tags|escape:'html'|truncate:60}" class="btn btn-xs">{$newsCategory->getName()}</a>
                    {/foreach}
                </div>
            {/if}
        </div>

        {if isset($Einstellungen.news.news_kommentare_nutzen) && $Einstellungen.news.news_kommentare_nutzen === 'Y'}
        <div id="nw-cmt">
            {if $comments|count > 0}
                {if !empty($oNewsArchiv->getSeo())}
                    {assign var=articleURL value=$oNewsArchiv->getURL()}
                    {assign var=cParam_arr value=[]}
                {else}
                    {assign var=articleURL value='news.php'}
                    {assign var=cParam_arr value=['kNews'=>$oNewsArchiv->getID(),'n'=>$oNewsArchiv->getID()]}
                {/if}
                <div class="mb-md" id="comments">
                    <h3 class="mb-sm">{lang key="newsComments" section="news"}</h3>
                    {foreach $comments as $comment}
                        <blockquote class="news-comment m0">
                            <p>
                                {$comment->getText()}
                            </p>
                            <small>{$comment->getName()}, {$comment->getDateCreated()->format('d.m.y H:i')}</small>
                        </blockquote>
                        {if !($comment@last)}<hr>{/if}
                    {/foreach}
                </div>
                {include file='snippets/pagination.tpl' oPagination=$oPagiComments cThisUrl=$articleURL cParam_arr=$cParam_arr noWrapper=true}
            {/if}

            {if $userCanComment === true}
            <div class="panel panel-default mt-md">
                <div class="panel-heading"><h4 class="panel-title">{lang key="newsCommentAdd" section="news"}</h4></div>
                <div class="panel-body">
                    <form method="post" action="{if !empty($oNewsArchiv->getSEO())}{$oNewsArchiv->getURL()}{else}{get_static_route id='news.php'}{/if}" class="form jtl-validate" id="news-addcomment">
                        {$jtl_token}
                        <input type="hidden" name="kNews" value="{$oNewsArchiv->getID()}" />
                        <input type="hidden" name="kommentar_einfuegen" value="1" />
                        <input type="hidden" name="n" value="{$oNewsArchiv->getID()}" />

                        <fieldset>
                            <div class="form-group float-label-control{if $nPlausiValue_arr.cKommentar > 0} has-error{/if} required">
                                <label class="control-label" for="comment-text"><strong>{lang key="newsComment" section="news"}</strong></label>
                                <textarea id="comment-text" class="form-control" name="cKommentar" required></textarea>
                                {if $nPlausiValue_arr.cKommentar > 0}
                                    <div class="form-error-msg text-danger">
                                        {lang key="fillOut" section="global"}
                                    </div>
                                {/if}
                            </div>
                            <p class="small text-muted">(* = {lang key='mandatoryFields'})</p>
                            <input class="btn btn-primary" name="speichern" type="submit" value="{lang key="newsCommentSave" section="news"}" />
                        </fieldset>
                    </form>
                </div>
            </div>{* /panel *}
            {else}
                <hr>
                <div class="alert alert-danger">{lang key="newsLogin" section="news"}</div>
            {/if}
        </div>
        {/if}
    </article>
{/if}
{/block}
