{block name='snackys-content-image'}
<div class="image  {$entry->cClass}">
	{if $entry->cLink != ""}<a href="{$entry->cLink}">{/if}
	<span class="img-ct">
		{image src=$entry->cBild alt="{$entry->cCaption|trans}"}
	</span>
	{if $entry->cCaption != ""}
		<span class="block caption">{$entry->cCaption}</span>
	{/if}
	{if $entry->cLink != ""}</a>{/if}
</div>
{/block}