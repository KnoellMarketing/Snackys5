{block name='checkout-inc-steps'}
{assign var="step1_active" value=($bestellschritt[1] == 1 || $bestellschritt[2] == 1)}
{assign var="step2_active" value=($bestellschritt[3] == 1 || $bestellschritt[4] == 1)}
{assign var="step3_active" value=($bestellschritt[5] == 1)}
{assign var="coupon" value=""}
{if $bestellschritt[1] != 3}
	{strip}
    <ul class="nav nav-wizard first blanklist"
	data-track-type="start"
	{if $step1_active}data-track-event="begin_checkout"{/if}
	{if $step2_active}data-track-event="checkout_progress" data-track-p-checkout_step="1"{/if}
	{if $step3_active}data-track-event="checkout_progress" data-track-p-checkout_step="2"{/if}
	data-track-p-value="{$smarty.session.Warenkorb->gibGesamtsummeWaren()}" data-track-p-currency="{$smarty.session.Waehrung->cISO}" 
	data-track-p-items='[{foreach name=artikel from=$smarty.session.Warenkorb->PositionenArr item=Artikel}
		{if !$smarty.foreach.artikel.first},{/if}
		{if $Artikel->nPosTyp == $C_WARENKORBPOS_TYP_ARTIKEL}{ldelim}"id":"{if $snackyConfig.artnr == "id"}{$Artikel->Artikel->kArtikel}{else}{$Artikel->Artikel->cArtNr}{/if}","name":"{$Artikel->Artikel->cName|escape}","price":"{$Artikel->Artikel->Preise->fVKNetto}","quantity":"{$Artikel->nAnzahl}"{rdelim}
		{else}{if $Artikel->nPosTyp==3}{assign var="coupon" value=$Artikel->cName|trans|replace:'"':''}{/if}{ldelim}"id":"PosTyp_{$Artikel->nPosTyp}","name":"PosTyp{$Artikel->nPosTyp}:{$Artikel->cName|escape}","price":"{$Artikel->fPreis}","quantity":"{$Artikel->nAnzahl}"{rdelim}{/if}

	{/foreach}]'
	{if $coupon!=""}data-track-p-coupon="{$coupon}"{/if}
	>
	{/strip}
        {if $bestellschritt[1] < 3 || $bestellschritt[2] < 3}
        <li class="{if $step1_active}active{/if}">
                <a href="{get_static_route id='bestellvorgang.php'}?editRechnungsadresse=1" title="{lang section='account data' key='billingAndDeliveryAddress'}">
                    <h2 class="h3 m0">1. {lang section='account data' key='billingAndDeliveryAddress'}</h2>
                    {if !($step1_active)}
						<div class="img-ct icon icon-wt">
							<svg>
							  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-edit"></use>
							</svg>
						</div>
					{/if}
                </a>
        </li>
        {/if}
        {if $bestellschritt[3] < 3 || $bestellschritt[4] < 3}
        <li class="{if $step2_active}active{/if}">
                <a href="{get_static_route id='bestellvorgang.php'}?editVersandart=1" title="{lang section='account data' key='shippingAndPaymentOptions'}">
                    <h2 class="h3 m0">2. {lang section='account data' key='shippingAndPaymentOptions'}</h2>
                    {if !($step2_active)}
						<div class="img-ct icon icon-wt">
							<svg>
							  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg#icon-edit"></use>
							</svg>
						</div>
					{/if}
                </a>
        </li>
        {/if}
        {if $step3_active}
        <li class="active">
            <span class="nav-badge">
                <h2 class="h3 m0">3. {lang section='checkout' key='summary'}</h2>
            </span>
        </li>
        {/if} 
    </ul>
{/if}
{/block}