{block name='snippets-slider'}
{if isset($oSlider) && count($oSlider->getSlides()) > 0}
	{include file="snippets/zonen.tpl" id="opc_before_slider"}
    <div class="sl-w panel-slider">
		{if isset($oSlider) && count($oSlider->getSlides()) > 1 && !$isMobile && $oSlider->nPauseTime<=300}
			<span class="sl-ar sl-pr btn inactive">
				<span class="ar ar-l"></span>
			</span>
		{/if}
        <div id="slider-{$oSlider->kSlider}" class="fw-sl no-scrollbar"{if $oSlider->nPauseTime>300} data-autoplay="{$oSlider->nPauseTime}"{/if}>
            {foreach from=$oSlider->getSlides() item=oSlide}
                {assign var="slideTitle" value=$oSlide->getTitle()}
                {if !empty($oSlide->getText())}
                    {assign var="slideTitle" value="#slide_caption_{$oSlide->getID()}"}
                {/if}
                {if !empty($oSlide->getLink())}
                    <a href="{$oSlide->getLink()}" class="slide">
                {else}
                    <div class="slide">
                {/if}
				<div class="img-ct">
					{image src=$oSlide->getAbsoluteImage() lazy=true alt="{if !empty($oSlide->getTitle())}{$oSlide->getTitle()}{else}Slide{/if}"}
                </div>
                    {if !empty($oSlide->getText()) || !empty($oSlide->getTitle())}
                        <div id="slide_caption_{$oSlide->getID()}" class="htmlcaption">
                            {if isset($oSlide->getTitle())}<strong class="title h4">{$oSlide->getTitle()}</strong>{/if}
                            <p class="desc">{$oSlide->getText()}</p>
                        </div>
                    {/if}

                {if !empty($oSlide->getLink())}
                    </a>
                {else}
                    </div>
                {/if}
            {/foreach}
        </div>
		{if isset($oSlider) && count($oSlider->getSlides()) > 1 && !$isMobile && $oSlider->nPauseTime<=300}
			<span class="sl-ar sl-nx btn">
				<span class="ar ar-r"></span>
			</span>
		{/if}
    </div>
	
	{assign var="firstSlide" value=$oSlider->getSlides()}
	{getSizeBySrc src="{$firstSlide[0]->getAbsoluteImage()}" cAssign="sliderSize"}
	{if !empty($sliderSize.padding)}
	<style type="text/css">
	.fw-sl .img-ct:before {ldelim} padding-top: {$sliderSize.padding}%;{rdelim}
	</style>
	{/if}
{/if}
{/block}