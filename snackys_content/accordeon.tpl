{block name='snackys-content-accordeon'}
<div class="accordeon  {$entry->cClass}" id="accordeon-{$entry-id}">
	{foreach from=$entry->subs item="sub" name="accordeon"}
	<div class="card">
        <a class="card-header card-link block" data-toggle="collapse"	href="#accordeon-{$entry-id}-{$smarty.foreach.accordeon.iteration}">  
            <span class="toggle"></span> <strong>{$sub->cNamePanel}</strong>
        </a> 
		<div id="accordeon-{$entry-id}-{$smarty.foreach.accordeon.iteration}" 
		class="collapse{if $smarty.foreach.accordeon.iteration == 1} in{/if}" 
		data-parent="#accordeon-{$entry-id}"> 
			<div class="card-body"> 
				{$sub->cContent}
			</div> 
		</div>
	</div>
	{/foreach}
</div>
{/block}