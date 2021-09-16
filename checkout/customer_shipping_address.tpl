{block name='checkout-shipping-adress-form'}
{$name = 'shipping_address'}
{* salutation / title *}
<div class="row">
    {if $Einstellungen.kunden.lieferadresse_abfragen_anrede !== 'N'}
        <div class="col-12 col-md-6">
            <div class="form-group float-label-control{if !empty($fehlendeAngaben.anrede)} has-error{/if}{if $Einstellungen.kunden.lieferadresse_abfragen_anrede === 'Y'} required{/if}">
                <label for="{$prefix}-{$name}-salutation" class="control-label">{lang key="salutation" section="account data"}</label>
                <select name="{$prefix}[{$name}][anrede]" id="{$prefix}-{$name}-salutation" class="form-control" {if $Einstellungen.kunden.lieferadresse_abfragen_anrede === 'Y'}required{/if}>
                    <option value="" selected="selected" {if $Einstellungen.kunden.lieferadresse_abfragen_anrede === 'Y'}disabled{/if}>
						 {if $Einstellungen.kunden.lieferadresse_abfragen_anrede === 'Y'}{lang key='salutation' section='account data'}{else}{lang key='noSalutation'}{/if}
					</option>
                    <option value="w"{if isset($Lieferadresse->cAnrede) && $Lieferadresse->cAnrede === 'w'} selected="selected"{/if}>{lang key='salutationW'}</option>
                    <option value="m"{if isset($Lieferadresse->cAnrede) && $Lieferadresse->cAnrede === 'm'} selected="selected"{/if}>{lang key='salutationM'}</option>
                </select>
                {if !empty($fehlendeAngaben.anrede)}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {/if}
            </div>
        </div>
    {/if}
    {if $Einstellungen.kunden.lieferadresse_abfragen_titel !== 'N'}
        <div class="col-12 col-md-6">
            <div class="form-group float-label-control{if !empty($fehlendeAngaben.titel)} has-error{/if}{if $Einstellungen.kunden.lieferadresse_abfragen_titel === 'Y'} required{/if}">
                <label for="{$prefix}-{$name}-title" class="control-label">{lang key="title" section="account data"}</label>
                <input type="text" name="{$prefix}[{$name}][titel]" value="{if isset($Lieferadresse->cTitel)}{$Lieferadresse->cTitel}{/if}" id="{$prefix}-{$name}-title" class="form-control" placeholder="{lang key="title" section="account data"}"{if $Einstellungen.kunden.lieferadresse_abfragen_titel === 'Y'} required{/if} {if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternTitel)}pattern="{$snackyConfig.patternTitel}"{/if} spellcheck="false"  autocorrect="off">
                {if !empty($fehlendeAngaben.titel)}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {/if}
            </div>
        </div>
    {/if}
</div>

{* firstname lastname *}
<div class="row">
    <div class="col-12 col-md-6">
        <div class="form-group float-label-control{if !empty($fehlendeAngaben.vorname)} has-error{/if}{if $Einstellungen.kunden.kundenregistrierung_pflicht_vorname === 'Y'} required{/if}">
            <label for="{$prefix}-{$name}-firstName" class="control-label">{lang key="firstName" section="account data"}</label>
            <input type="text" name="{$prefix}[{$name}][vorname]" value="{if isset($Lieferadresse->cVorname)}{$Lieferadresse->cVorname}{/if}" id="{$prefix}-{$name}-firstName" class="form-control" placeholder="{lang key="firstName" section="account data"}"{if $Einstellungen.kunden.kundenregistrierung_pflicht_vorname === 'Y'} required{/if} {if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternVorname)}pattern="{$snackyConfig.patternVorname}"{/if} spellcheck="false"  autocorrect="off">
            {if !empty($fehlendeAngaben.vorname)}
                {if $fehlendeAngaben.vorname == 1}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {elseif $fehlendeAngaben.vorname == 2}
                    <div class="alert alert-danger">{lang key="firstNameNotNumeric" section="account data"}</div>
                {/if}
            {/if}
        </div>
    </div>
    <div class="col-12 col-md-6">
        <div class="form-group float-label-control{if !empty($fehlendeAngaben.nachname)} has-error{/if} required">
            <label for="{$prefix}-{$name}-lastName" class="control-label">{lang key="lastName" section="account data"}</label>
            <input type="text" name="{$prefix}[{$name}][nachname]" value="{if isset($Lieferadresse->cNachname)}{$Lieferadresse->cNachname}{/if}" id="{$prefix}-{$name}-lastName" class="form-control" placeholder="{lang key="lastName" section="account data"}" required {if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternNachname)}pattern="{$snackyConfig.patternNachname}"{/if} spellcheck="false"  autocorrect="off"/>
            {if !empty($fehlendeAngaben.nachname)}
                {if $fehlendeAngaben.nachname == 1}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {elseif $fehlendeAngaben.nachname == 2}
                    <div class="alert alert-danger">{lang key="lastNameNotNumeric" section="account data"}</div>
                {/if}
            {/if}
        </div>
    </div>
</div>

{* firm / firmtext *}
<div class="row">
    {if $Einstellungen.kunden.kundenregistrierung_abfragen_firma !== 'N'}
        <div class="col-12 col-md-6">
            <div class="form-group float-label-control{if !empty($fehlendeAngaben.firma)} has-error{/if}{if $Einstellungen.kunden.kundenregistrierung_abfragen_firma === 'Y'} required{/if}">
                <label for="{$prefix}-{$name}-firm" class="control-label">{lang key="firm" section="account data"}</label>
                <input type="text" name="{$prefix}[{$name}][firma]" value="{if isset($Lieferadresse->cFirma)}{$Lieferadresse->cFirma}{/if}" id="{$prefix}-{$name}-firm" class="form-control" placeholder="{lang key="firm" section="account data"}"{if $Einstellungen.kunden.kundenregistrierung_abfragen_firma === 'Y'} required{/if} spellcheck="false"  autocorrect="off">
                {if !empty($fehlendeAngaben.firma)}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {/if}
            </div>
        </div>
    {/if}
    {if $Einstellungen.kunden.kundenregistrierung_abfragen_firmazusatz !== 'N'}
        <div class="col-12 col-md-6">
            <div class="form-group float-label-control{if !empty($fehlendeAngaben.firmazusatz)} has-error{/if}{if $Einstellungen.kunden.kundenregistrierung_abfragen_firmazusatz === 'Y'} required{/if}">
                <label for="{$prefix}-{$name}-firmext" class="control-label">{lang key="firmext" section="account data"}</label>
                <input type="text" name="{$prefix}[{$name}][firmazusatz]" value="{if isset($Lieferadresse->cZusatz)}{$Lieferadresse->cZusatz}{/if}" id="{$prefix}-{$name}-firmext" class="form-control" placeholder="{lang key="firmext" section="account data"}"{if $Einstellungen.kunden.kundenregistrierung_abfragen_firmazusatz === 'Y'} required{/if} spellcheck="false"  autocorrect="off">
                {if !empty($fehlendeAngaben.firmazusatz)}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {/if}
            </div>
        </div>
    {/if}
</div>

{* street / number *}
<div class="row">
    <div class="col-12 col-md-6">
        <div class="form-group float-label-control{if !empty($fehlendeAngaben.strasse)} has-error{/if} required">
            <label class="control-label" for="{$prefix}-{$name}-street">{lang key="street" section="account data"}</label>
            <input type="text" name="{$prefix}[{$name}][strasse]" value="{if isset($Lieferadresse->cStrasse)}{$Lieferadresse->cStrasse}{/if}" id="{$prefix}-{$name}-street" class="form-control" placeholder="{lang key="street" section="account data"}*" required	{if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternStrasse)}pattern="{$snackyConfig.patternStrasse}"{/if} spellcheck="false"  autocorrect="off">
            {if !empty($fehlendeAngaben.strasse)}
                <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
            {/if}
        </div>
    </div>
    <div class="col-12 col-md-6">
        <div class="form-group float-label-control{if !empty($fehlendeAngaben.hausnummer)} has-error{/if} required">
            <label class="control-label" for="{$prefix}-{$name}-streetnumber">{lang key="streetnumber" section="account data"}</label>
            <input type="text" name="{$prefix}[{$name}][hausnummer]" value="{if isset($Lieferadresse->cHausnummer)}{$Lieferadresse->cHausnummer}{/if}" id="{$prefix}-{$name}-streetnumber" class="form-control" placeholder="{lang key="streetnumber" section="account data"}*" required {if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternHausnummer)}pattern="{$snackyConfig.patternHausnummer}"{/if} spellcheck="false"  autocorrect="off"/>
            {if !empty($fehlendeAngaben.hausnummer)}
                <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
            {/if}
        </div>
    </div>
</div>

{* adress addition *}
{if $Einstellungen.kunden.lieferadresse_abfragen_adresszusatz !== 'N'}
    <div class="row">
        <div class="col-12 col-md-6">
            <div class="form-group float-label-control{if !empty($fehlendeAngaben.adresszusatz)} has-error{/if}{if $Einstellungen.kunden.lieferadresse_abfragen_adresszusatz === 'Y'} required{/if}">
                <label class="control-label" for="{$prefix}-{$name}-street2">{lang key="street2" section="account data"}</label>
                <input type="text" name="{$prefix}[{$name}][adresszusatz]" value="{if isset($Lieferadresse->cAdressZusatz)}{$Lieferadresse->cAdressZusatz}{/if}" id="{$prefix}-{$name}-street2" class="form-control" placeholder="{lang key="street2" section="account data"}"{if $Einstellungen.kunden.lieferadresse_abfragen_adresszusatz === 'Y'} required{/if} {if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternAdresszusatz)}pattern="{$snackyConfig.patternAdresszusatz}"{/if} spellcheck="false"  autocorrect="off">
                {if !empty($fehlendeAngaben.adresszusatz)}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {/if}
            </div>
        </div>
    </div>
{/if}

{* country *}
{if isset($Lieferadresse->cLand)}
    {assign var='cIso' value=$Lieferadresse->cLand}
{elseif !empty($Kunde->cLand)}
    {assign var='cIso' value=$Kunde->cLand}
{else}
    {assign var='cIso' value=$shippingCountry}
{/if}
<div class="row">
    <div class="col-12 col-md-6">
        <div class="form-group float-label-control">
            <label class="control-label" for="{$prefix}-{$name}-country">{lang key="country" section="account data"}</label>
            <select name="{$prefix}[{$name}][land]" id="{$prefix}-{$name}-country" class="country_input form-control" autocomplete="shipping country">
                <option value="" selected disabled>{lang key="country" section="account data"}*</option>
                {foreach $LieferLaender as $land}
                    <option value="{$land->getISO()}" {if $cIso == $land->getISO()}selected="selected"{/if}>{$land->getName()}</option>
                {/foreach}
            </select>
        </div>
    </div>
    {if $Einstellungen.kunden.lieferadresse_abfragen_bundesland !== 'N'}
        {getStates cIso=$cIso assign='oShippingStates'}
        {if isset($Lieferadresse->cBundesland)}
            {assign var='cState' value=$Lieferadresse->cBundesland}
        {elseif !empty($Kunde->cBundesland)}
            {assign var='cState' value=$Kunde->cBundesland}
        {else}
            {assign var='cState' value=''}
        {/if}
        <div class="col-12 col-md-6">
            <div class="form-group float-label-control{if !empty($fehlendeAngaben.bundesland)} has-error{/if}{if $Einstellungen.kunden.lieferadresse_abfragen_bundesland === 'Y'} required{/if}">
                <label class="control-label" for="{$prefix}-{$name}-state">{lang key='state' section='account data'}
                    {if $Einstellungen.kunden.lieferadresse_abfragen_bundesland !== 'Y'}
                        <span class="optional"> - {lang key='optional'}</span>
                    {/if}
                </label>
                {if !empty($oShippingStates)}
                    <select
                            title="{lang key=pleaseChoose}"
                            name="{$prefix}[{$name}][bundesland]"
                            id="{$prefix}-{$name}-state"
                            class="form-control state-input"
                            autocomplete="shipping address-level1"
                            {if $Einstellungen.kunden.lieferadresse_abfragen_bundesland === 'Y'} required{/if}
                    >
                        <option value="" selected disabled>{lang key='pleaseChoose' section='global'}</option>
                        {foreach $oShippingStates as $oState}
                            <option value="{$oState->cCode}" {if $cState === $oState->cName || $cState === $oState->cCode}selected{/if}>{$oState->cName}</option>
                        {/foreach}
                    </select>
                {else}
                    <input
                        type="text"
                        title="{lang key=pleaseChoose}"
                        name="{$prefix}[{$name}][bundesland]"
                        value="{if isset($Lieferadresse->cBundesland)}{$Lieferadresse->cBundesland}{/if}"
                        id="{$prefix}-{$name}-state"
                        class="form-control"
                        data-toggle="state" data-target="#{$prefix}-{$name}-country"
                        placeholder="{lang key='state' section='account data'}"{if $Einstellungen.kunden.lieferadresse_abfragen_bundesland === 'Y'} required{/if}
                        autocomplete="shipping address-level1">
                {/if}
                {if !empty($fehlendeAngaben.bundesland)}
                    <div class="alert alert-danger">{lang key="fillOut" section="global"}</div>
                {/if}
            </div>
        </div>
    {/if}
</div>

{* zip / city *}
<div class="row">
    <div class="col-12 col-md-6">
        <div class="form-group float-label-control{if !empty($fehlendeAngaben.plz)} has-error{/if} required">
            <label class="control-label" for="{$prefix}-{$name}-postcode">{lang key="plz" section="account data"}</label>
            <input
                type="text"
                name="{$prefix}[{$name}][plz]"
                value="{if isset($Lieferadresse->cPLZ)}{$Lieferadresse->cPLZ}{/if}"
                id="{$prefix}-{$name}-postcode"
                class="postcode_input form-control"
                placeholder="{lang key="plz" section="account data"}"
                data-toggle="postcode" data-city="#{$prefix}-{$name}-city" data-country="#{$prefix}-{$name}-country"
                required {if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternPLZ)}pattern="{$snackyConfig.patternPLZ}"{/if}
				spellcheck="false"
				autocorrect="off"
				autocomplete="shipping postal-code"
				>
            {if isset($fehlendeAngaben.plz)}
                <div class="alert alert-danger">
                    {if $fehlendeAngaben.plz >= 2}
                        {lang key='checkPLZCity' section='checkout'}
                    {else}
                        {lang key='fillOut' section='global'}
                    {/if}
				</div>{/if}
        </div>
    </div>

    <div class="col-12 col-md-6">
        <div class="form-group float-label-control{if !empty($fehlendeAngaben.ort)} has-error{/if} required">
            <label class="control-label" for="{$prefix}-{$name}-city">{lang key="city" section="account data"}</label>
            <input type="text" name="{$prefix}[{$name}][ort]" value="{if isset($Lieferadresse->cOrt)}{$Lieferadresse->cOrt}{/if}" id="{$prefix}-{$name}-city" 
			class="city_input form-control" placeholder="{lang key="city" section="account data"}" required 
			{if $snackyConfig.formvalidActive === '0' && isset($snackyConfig.patternOrt)}pattern="{$snackyConfig.patternOrt}"{/if} 
			spellcheck="false"  autocorrect="off"
			autocomplete="shipping address-level2"
			>
            {if isset($fehlendeAngaben.ort)}
                {if $fehlendeAngaben.ort == 3}
                    <div class="alert alert-danger">{lang key="cityNotNumeric" section="account data"}</div>
                {else}
                    <div class="alert alert-danger">
						{if $fehlendeAngaben.ort==3}
							{lang key='cityNotNumeric' section='account data'}
						{else}
							{lang key='fillOut' section='global'}
						{/if}
					</div>
                {/if}
            {/if}
        </div>
    </div>
</div>
{/block}