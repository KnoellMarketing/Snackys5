{block name='snackys-content-image'}
<div class="image {$entry->cClass}">
	{if $entry->cLink != ""}<a href="{$entry->cLink}">{/if}
	<span class="img-ct">
		{if $entry->cBild|webpExists}
			{image src=$entry->cBild alt="{$entry->cAltTag}" lazy=true webp=true}
		{else}
			{image src=$entry->cBild alt="{$entry->cAltTag}" lazy=true}
		{/if}
	</span>
	{if $entry->cCaption != ""}
		<span class="block caption">{$entry->cCaption}</span>
	{/if}
	{if $entry->cLink != ""}</a>{/if}
</div>
{/block}