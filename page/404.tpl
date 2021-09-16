{block name='page-404'}
<div id="pnf" class="dpflex-a-center dpflex-j-center text-center" 
	 style="background: url('{if !empty($snackyConfig.error404BG)}{$snackyConfig.error404BG}{else}/templates/Snackys/img/background/bg-404.jpg{/if}')no-repeat center center/cover">
	<div class="content">
	   <h1>404</h1>
        <h2>{lang key="pagenotfound" section="breadcrumb"}</h2>
		<a href="index.php" class="btn btn-primary btn-lg">{lang key="goToStartpage" section="checkout"}</a>
	</div>
</div>
{/block}