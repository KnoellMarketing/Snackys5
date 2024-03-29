{block name='snackys-content-accordeon'}
	<div class="accordion  {$entry->cClass}" id="accordeon-{$entry->id}">
		{foreach from=$entry->subs item="sub" name="accordeon"}
			<div class="card">
				{block name='snackys-content-accordeon-title'}
					<a class="card-header card-link block" data-toggle="collapse" href="#accordeon-{$entry->id}-{$smarty.foreach.accordeon.iteration}">  
						<span class="toggle"></span> <strong>{$sub->cNamePanel}</strong>
					</a>
				{/block}
				{block name='snackys-content-accordeon-content'}
					<div id="accordeon-{$entry->id}-{$smarty.foreach.accordeon.iteration}" 
					class="collapse{if $smarty.foreach.accordeon.iteration == 1} show{/if}" 
					data-parent="#accordeon-{$entry->id}"> 
						<div class="card-body"> 
							{$sub->rendered}
						</div> 
					</div>
				{/block}
			</div>
		{/foreach}
	</div>
{/block}