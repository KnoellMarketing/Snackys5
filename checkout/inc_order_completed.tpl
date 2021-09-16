{block name='checkout-inc-order-completed'}
<div id="order-confirmation">
    {block name="checkout-order-confirmation"}
    <div class="row">
        <div class="col-12 col-md-4 col-lg-3 al-wp">
            <div class="panel small">
                <div class="panel-heading h4">
                    {lang key="orderCompletedPre" section="checkout"}: {$Bestellung->cBestellNr} 
                </div>
                <div class="panel-title h6 mb-xxs">
                    {lang key="billingAdress" section="checkout"}
                </div>
                {$Bestellung->oRechnungsadresse->cVorname} {$Bestellung->oRechnungsadresse->cNachname}
                <br>{$Bestellung->oRechnungsadresse->cStrasse} {$Bestellung->oRechnungsadresse->cHausnummer}
                <br>{$Bestellung->oRechnungsadresse->cPLZ} {$Bestellung->oRechnungsadresse->cOrt}
                <br>{$Bestellung->oRechnungsadresse->angezeigtesLand}
                <br>
                <br>{$Bestellung->oRechnungsadresse->cMail}
                <hr>
                <div class="panel-title h6 mb-xxs">
                    {lang key="shippingAdress" section="checkout"}
                </div>
                {$Bestellung->Lieferadresse->cVorname} {$Bestellung->Lieferadresse->cNachname}
                <br>{$Bestellung->Lieferadresse->cStrasse} {$Bestellung->Lieferadresse->cHausnummer}
                <br>{$Bestellung->Lieferadresse->cPLZ} {$Bestellung->Lieferadresse->cOrt}
                <br>{$Bestellung->Lieferadresse->angezeigtesLand}
                <br>
                {$Bestellung->Lieferadresse->cMail}
                <hr>
                <div class="panel-title h6 mb-xxs">
                    {lang key="paymentMethod" section="checkout"} 
                </div>
                {$Bestellung->cZahlungsartName}
                <hr>
                <div class="panel-title h6 mb-xxs">
                    {lang key="shipmentMode" section="checkout"}
                </div>
                {$Bestellung->oVersandart->cName}<br>
                <strong>{lang key="shippingTime"}</strong>: {$Bestellung->cEstimatedDeliveryEx}
            </div>
        </div>
        <div class="col-12 col-md-8 col-lg-9">
            {if isset($smarty.session.Zahlungsart->nWaehrendBestellung) && $smarty.session.Zahlungsart->nWaehrendBestellung == 1}
                <h1 class="mb-spacer mb-small">{lang key="orderCompletedPre" section="checkout"}</h1>
            {elseif $Bestellung->Zahlungsart->cModulId !== 'za_kreditkarte_jtl' && $Bestellung->Zahlungsart->cModulId !== 'za_lastschrift_jtl'}
                <h1 class="mb-spacer mb-small">{lang key="orderCompletedPost" section="checkout"}</h1>
            {/if}
            <div class="alert alert-info">{lang key="orderConfirmationPost" section="checkout"}</div>
            {include file='account/order_item.tpl' tplscope='confirmation'}
        </div>
    </div>
    {/block}
</div>

{/block}