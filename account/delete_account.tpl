{block name='account-delete-account'}
	{block name='account-delete-account-headline'}
		<h1 class="h2">{lang key="deleteAccount" section="login"}</h1>
	{/block}
	{block name='account-delete-account-text'}
		<p class="text-danger">{lang key='reallyDeleteAccount' section='login'}</p>
	{/block}
	{block name='account-delete-account-form'}
		<form id="delete_account" action="{get_static_route id='jtl.php'}" method="post">
			{$jtl_token}
			<input type="hidden" name="del_acc" value="1" />
			<input type="submit" class="submit btn btn-danger" value="{lang key="deleteAccount" section="login"}" />
		</form>
	{/block}
{/block}