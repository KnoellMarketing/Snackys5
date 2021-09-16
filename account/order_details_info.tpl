{if isset($Kunde) && $Kunde->kKunde > 0}
    {block name="order-details-billing-address"}
        <div class="panel-title h6 mb-xxs">{block name="order-details-billing-address-title"}{lang key="billingAdress" section="checkout"}{/block}</div>
        {include file='checkout/inc_billing_address.tpl' Kunde=$billingAddress}
        <hr>
    {/block}
    {block name="order-details-shipping-address"}
        {if !empty($Lieferadresse->kLieferadresse)}
            <div class="panel-title h6 mb-xxs">{block name="order-details-shipping-address-title"}{lang key="shippingAdress" section="checkout"}{/block}</div>
            {include file='checkout/inc_delivery_address.tpl'}
        {else}
            <div class="panel-title h6 mb-xxs">{block name="order-details-shipping-address-title"}{lang key="shippingAdress" section="checkout"}{/block}</div>
            <p>{lang key="shippingAdressEqualBillingAdress" section="account data"}</p>
        {/if}
        <hr>
    {/block}
    {block name="order-details-payment"}
    <div class="panel-title h6 mb-xxs">{block name="order-details-payment-title"}{lang key="paymentOptions" section="global"}: {$Bestellung->cZahlungsartName}{/block}</div>
    {block name="order-details-payment-body"}
        {if $Bestellung->cStatus != BESTELLUNG_STATUS_STORNO && $Bestellung->dBezahldatum_de !== '00.00.0000' && !empty($Bestellung->dBezahldatum_de)}
            {lang key='payedOn' section='login'} {$Bestellung->dBezahldatum_de}
        {else}
            {if ($Bestellung->cStatus == BESTELLUNG_STATUS_OFFEN || $Bestellung->cStatus == BESTELLUNG_STATUS_IN_BEARBEITUNG) && (($Bestellung->Zahlungsart->cModulId !== 'za_ueberweisung_jtl' && $Bestellung->Zahlungsart->cModulId !== 'za_nachnahme_jtl' && $Bestellung->Zahlungsart->cModulId !== 'za_rechnung_jtl' && $Bestellung->Zahlungsart->cModulId !== 'za_barzahlung_jtl') && (isset($Bestellung->Zahlungsart->bPayAgain) && $Bestellung->Zahlungsart->bPayAgain))}
                <a href="bestellab_again.php?kBestellung={$Bestellung->kBestellung}">{lang key='payNow' section='global'}</a>
            {else}
                {lang key='notPayedYet' section='login'}
            {/if}
        {/if}
    {/block}
    {/block}
    <hr>
    {block name="order-details-shipping"}
    <div class="panel-title h6 mb-xxs">{block name="order-details-shipping-title"}{lang key="shippingOptions" section="global"}: {$Bestellung->cVersandartName}{/block}</div>
    {block name='order-details-shipping-body'}
    {if $Bestellung->cStatus == BESTELLUNG_STATUS_VERSANDT}
        {lang key='shippedOn' section='login'} {$Bestellung->dVersanddatum_de}
    {elseif $Bestellung->cStatus == BESTELLUNG_STATUS_TEILVERSANDT}
        {$Bestellung->Status}
    {else}
        <p>{lang key='notShippedYet' section='login'}</p>
        {if $Bestellung->cStatus != BESTELLUNG_STATUS_STORNO}
        <p><strong>{lang key='shippingTime' section='global'}</strong>: {if isset($cEstimatedDeliveryEx)}{$cEstimatedDeliveryEx}{else}{$Bestellung->cEstimatedDelivery}{/if}</p>
        {/if}
    {/if}
    {/block}
    {/block}

	{if $Bestellung->oLieferschein_arr|@count > 0}
	{block name="order-details-delivery-note"}
		<div class="panel-title h6 mb-xxs">{if $Bestellung->cStatus == BESTELLUNG_STATUS_TEILVERSANDT}{lang key='partialShipped' section='order'}{else}{lang key='shipped' section='order'}{/if}</div>
		<div class="table-responsive">
			<table class="table table-striped table-bordered">
				<thead>
					<tr>
						<th>{lang key='shippingOrder' section='order'}</th>
						<th>{lang key='shippedOn' section='login'}</th>
						<th class="text-right">{lang key='packageTracking' section='order'}</th>
					</tr>
				</thead>
				<tbody>
					{foreach $Bestellung->oLieferschein_arr as $oLieferschein}
						<tr>
							<td><a class="popup-dep" id="{$oLieferschein->getLieferschein()}" href="#" title="{$oLieferschein->getLieferscheinNr()}">{$oLieferschein->getLieferscheinNr()}</a></td>
							<td>{$oLieferschein->getErstellt()|date_format:"%d.%m.%Y %H:%M"}</td>
							<td class="text-right">{foreach $oLieferschein->oVersand_arr as $oVersand}{if $oVersand->getIdentCode()}<p><a href="{$oVersand->getLogistikVarUrl()}" target="_blank" class="shipment" title="{$oVersand->getIdentCode()}">{lang key='packageTracking' section='order'}</a></p>{/if}{/foreach}</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	 
		{* Lieferschein Popups *}
		{foreach $Bestellung->oLieferschein_arr as $oLieferschein}
			{block name='order-details-delivery-note-popup'}
			<div id="popup{$oLieferschein->getLieferschein()}" class="hidden">
				<h1>{if $Bestellung->cStatus == BESTELLUNG_STATUS_TEILVERSANDT}{lang key='partialShipped' section='order'}{else}{lang key='shipped' section='order'}{/if}</h1>
				<div class="well well-sm">
					<strong>{lang key='shippingOrder' section='order'}</strong>: {$oLieferschein->getLieferscheinNr()}<br />
					<strong>{lang key='shippedOn' section='login'}</strong>: {$oLieferschein->getErstellt()|date_format:"%d.%m.%Y %H:%M"}<br />
				</div>

				{if $oLieferschein->getHinweis()|@count_characters > 0}
					<div class="alert alert-info">
						{$oLieferschein->getHinweis()}
					</div>
				{/if}

				<div class="well well-sm">
					{foreach $oLieferschein->oVersand_arr as $oVersand}{if $oVersand->getIdentCode()}<p><a href="{$oVersand->getLogistikVarUrl()}" target="_blank" class="shipment" title="{$oVersand->getIdentCode()}">{lang key='packageTracking' section='order'}</a></p>{/if}{/foreach}
				</div>

				<div class="well well-sm">
					<table class="table table-striped">
						<thead>
							<tr>
								<th>{lang key="partialShippedPosition" section="order"}</th>
								<th>{lang key="partialShippedCount" section="order"}</th>
								<th>{lang key='productNo' section='global'}</th>
								<th>{lang key='product' section='global'}</th>
								<th>{lang key="order" section="global"}</th>
							</tr>
						</thead>
						<tbody>
							{foreach $oLieferschein->oLieferscheinPos_arr as $oLieferscheinpos}
								<tr>
									<td>{$oLieferscheinpos@iteration}</td>
									<td>{$oLieferscheinpos->getAnzahl()}</td>
									<td>{$oLieferscheinpos->oPosition->cArtNr}</td>
									<td>
										{$oLieferscheinpos->oPosition->cName}
										<ul class="list-unstyled text-muted small">
											{if !empty($oLieferscheinpos->oPosition->cHinweis)}
												<li class="text-info notice">{$oLieferscheinpos->oPosition->cHinweis}</li>
											{/if}

											{* eindeutige Merkmale *}
											{if $oLieferscheinpos->oPosition->Artikel->cHersteller && $Einstellungen.artikeldetails.artikeldetails_hersteller_anzeigen != "N"}
												<li class="manufacturer">
													<strong>{lang key='manufacturer' section='productDetails'}</strong>:
													<span class="values">
													   {$oLieferscheinpos->oPosition->Artikel->cHersteller}
													</span>
												</li>
											{/if}

											{if $Einstellungen.kaufabwicklung.bestellvorgang_artikelmerkmale == 'Y' && !empty($oLieferscheinpos->oPosition->Artikel->oMerkmale_arr)}
												{foreach $oLieferscheinpos->oPosition->Artikel->oMerkmale_arr as $oMerkmale_arr}
													<li class="characteristic">
														<strong>{$oMerkmale_arr->cName}</strong>:
														<span class="values">
															{foreach $oMerkmale_arr->oMerkmalWert_arr as $oWert}
																{if !$oWert@first}, {/if}
																{$oWert->cWert}
															{/foreach}
														</span>
													</li>
												{/foreach}
											{/if}
										</ul>
									</td>
									<td>{$Bestellung->cBestellNr}</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</div>
			{/block}
		{/foreach}
	{/block}
	{/if}

	{if $Bestellung->cKommentar}
    <hr>
		<div class="panel-title h6 mb-xxs">{lang key="yourOrderComment" section="login"}</div>
		<p>{$Bestellung->cKommentar}</p>
	{/if}
{else}
    {block name='order-details-request-plz'}
        <div class="row">
            <div class="col-12 col-md-6">
                <form method="post" id='request-plz' action="{get_static_route}" class="evo-validate">
                    <input type="hidden" name="uid" value="{$uid}" />
                    <p>{lang key='enter_plz_for_details' section='account data'}</p>
                    <div class="form-group">
                        <input type="text" name="plz" value="" id="postcode" class="form-control" placeholder="{lang key='plz' section='account data'}" required="required" autocomplete="billing postal-code" />
                    </div>
                    <button class="btn btn-primary">{lang key='view' section='global'}</button>
                </form>
            </div>
        </div>
    {/block}
{/if}