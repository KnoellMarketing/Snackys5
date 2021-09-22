{block name='blog-preview'}
<div class="panel panel-default">    
    {if !empty($newsItem->getPreviewImage())}
        <div class="img-w">
            <a href="{$newsItem->getURL()}" title="{$newsItem->getTitle()|escape:'quotes'}">
                <span class="img-ct rt4x3">
						{include file='snippets/image.tpl'
							item=$newsItem
							square=false
							 class="img-responsive center-block"
							alt="{$title} - {$newsItem->getMetaTitle()|escape:'quotes'}"}
                </span>
            </a>
        </div>
    {/if}
    <div class="panel-heading hide-overflow m0">
        <div class="panel-title">
            <a href="{$newsItem->getURL()}" class="title">
                <span class="block h4 m0">{$newsItem->getTitle()}</span>
            </a>
            <div class="text-muted small dpflex-a-center v-box">
                {assign var='dDate' value=$newsItem->getDateValidFrom()->format('Y-m-d H:i:s')}
                {if $newsItem->getAuthor() !== null}
                    <div class="hidden-xs">{include file="snippets/author.tpl" oAuthor=$newsItem->getAuthor()}</div>
                {/if}
                <span class="block">{$newsItem->getDateCreated()->format('d.m.Y')}</span>
                {if isset($Einstellungen.news.news_kommentare_nutzen) && $Einstellungen.news.news_kommentare_nutzen === 'Y'}
                    <span class="separator">|</span>
                    <a class="dpflex-a-center" href="{$newsItem->getURL()}#comments" title="{lang key="readComments" section="news"}">
                        <span class="img-ct icon">
							<svg>
							  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-comment"></use>
							</svg>
						</span>
                        <span class="sr-only hidden">
                            {if $newsItem->getCommentCount() === 1}
                                {lang key="newsComment" section="news"}
                            {else}
                                {lang key="newsComments" section="news"}
                            {/if}
                        </span>
                        <span>{$newsItem->getCommentCount()}</span>
                    </a>
                {/if}
            </div>
        </div>
    </div>
    <div class="panel-body">
		<div>
			{if $newsItem->getPreview()|strip_tags|strlen > 0}
				{$newsItem->getPreview()|strip_tags}
			{else}
				{$newsItem->getContent()|strip_tags|truncate:300:"...":true}
			{/if}
		</div>
    </div>
    <a class="block title" href="{$newsItem->getURL()}">
        <strong>{lang key='moreLink' section='news'}</strong>
        </a>
    </span>
</div>
{/block}