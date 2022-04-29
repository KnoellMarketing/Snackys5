{if $id}
	{if !isset($title)}{assign var="title" value=$id}{/if}
	{assign var="snackys_id" value=$id|replace:"opc_":""}
	{snackys_content id=$snackys_id title=$title}
	{if (!isset($bAjaxRequest) || !$bAjaxRequest) && !isset($smarty.post.io)}
		{assign var="opc_id" value="opc_"|cat:$id}
		{opcMountPoint id=$opc_id title=$title}
	{/if}
{/if}