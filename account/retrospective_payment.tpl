{block name='account-retrospective-payment'}
<form id="form-payment-extra" class="form payment-extra" method="post" action="{get_static_route id='bestellab_again.php'}" slide=true>
    {$jtl_token}
    <fieldset class="outer">
        <input type="hidden" name="zusatzschritt" value="1" />
        <input type="hidden" name="kBestellung" value="{$Bestellung->kBestellung}" />

        {include file=$Bestellung->Zahlungsart->cZusatzschrittTemplate}

        <p class="box_plain">
            <input type="submit" value="{lang key="completeOrder" section="shipping payment"}" class="submit" />
        </p>
    </fieldset>
</form>
{/block}