{block name='checkout-step4-payment-additional'}
<form id="form_payment_extra" class="form payment_extra" method="post" action="{get_static_route id='bestellvorgang.php'}">
    <div id="order-additional-payment" class="bottom15 form-group">
        {$jtl_token}
        {include file=$Zahlungsart->cZusatzschrittTemplate}
        <input type="hidden" name="zahlungsartwahl" value="1" />
        <input type="hidden" name="zahlungsartzusatzschritt" value="1" />
        <input type="hidden" name="Zahlungsart" value="{$Zahlungsart->kZahlungsart}" />
    </div>
    <div class="text-right">
        <input type="submit" value="{lang key="continueOrder" section="account data"}" class="submit btn btn-lg submit_once btn-primary" />
    </div>
</form>
{/block}