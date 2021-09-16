{block name='productdetails-question-on-item'}
{if isset($fehlendeAngaben_fragezumprodukt)}
    {$fehlendeAngaben = $fehlendeAngaben_fragezumprodukt}
{/if}
<div class="panel-wrap">
    <form action="{if !empty($Artikel->cURLFull)}{$Artikel->cURLFull}{if $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen === 'Y'}#tab-productquestion{/if}{else}index.php{/if}" method="post" id="article_question" class="evo-validate">
        {$jtl_token}
        <fieldset class="panel">
            <span class="block h5">{lang key="contact"}</span>
            {if $Einstellungen.artikeldetails.produktfrage_abfragen_anrede !== 'N'}
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group float-label-control">
                            <label for="salutation" class="control-label">{lang key="salutation" section="account data"}</label>
                            <select name="anrede" id="salutation" class="form-control" autocomplete="honorific-prefix" {if $Einstellungen.artikeldetails.produktfrage_abfragen_anrede === 'Y'}required{/if}>
                                <option value="" {if $Einstellungen.artikeldetails.produktfrage_abfragen_anrede === 'Y'}disabled{/if} selected>
                                    {if $Einstellungen.artikeldetails.produktfrage_abfragen_anrede === 'Y'}{lang key='salutation' section='account data'}{else}{lang key='noSalutation'}{/if}
                                </option>
                                <option value="w" {if isset($Anfrage->cAnrede) && $Anfrage->cAnrede === 'w'}selected="selected"{/if}>{lang key='salutationW'}</option>
                                <option value="m" {if isset($Anfrage->cAnrede) && $Anfrage->cAnrede === 'm'}selected="selected"{/if}>{lang key='salutationM'}</option>
                            </select>
                        </div>
                    </div>
                </div>
            {/if}

            {if $Einstellungen.artikeldetails.produktfrage_abfragen_vorname !== 'N' || $Einstellungen.artikeldetails.produktfrage_abfragen_nachname !== 'N'}
                <div class="row">

                    {if $Einstellungen.artikeldetails.produktfrage_abfragen_vorname !== 'N'}
                        <div class="col-12 col-md-6">
                            <div class="form-group float-label-control {if isset($fehlendeAngaben_fragezumprodukt.vorname) && $fehlendeAngaben_fragezumprodukt.vorname > 0}has-error{/if}{if $Einstellungen.artikeldetails.produktfrage_abfragen_vorname === 'Y'} required{/if}">
                                <label class="control-label" for="firstName">{lang key="firstName" section="account data"}</label>
                                <input class="form-control" type="text" name="vorname" value="{if isset($Anfrage)}{$Anfrage->cVorname}{/if}" id="firstName"{if $Einstellungen.artikeldetails.produktfrage_abfragen_vorname === 'Y'} required{/if}>
                                {if isset($fehlendeAngaben_fragezumprodukt.vorname) && $fehlendeAngaben_fragezumprodukt.vorname > 0}
                                    <div class="form-error-msg text-danger"> {lang key="fillOut" section="global"}</div>
                                {/if}
                            </div>
                        </div>
                    {/if}

                    {if $Einstellungen.artikeldetails.produktfrage_abfragen_nachname !== 'N'}
                        <div class="col-12 col-md-6">
                            <div class="form-group float-label-control{if isset($fehlendeAngaben_fragezumprodukt.nachname) && $fehlendeAngaben_fragezumprodukt.nachname > 0} has-error{/if}{if $Einstellungen.artikeldetails.produktfrage_abfragen_nachname === 'Y'} required{/if}">
                                <label class="control-label" for="lastName">{lang key="lastName" section="account data"}</label>
                                <input class="form-control" type="text" name="nachname" value="{if isset($Anfrage)}{$Anfrage->cNachname}{/if}" id="lastName"{if $Einstellungen.artikeldetails.produktfrage_abfragen_nachname === 'Y'} required{/if}>
                                {if isset($fehlendeAngaben_fragezumprodukt.nachname) && $fehlendeAngaben_fragezumprodukt.nachname > 0}
                                    <div class="form-error-msg text-danger"> {lang key="fillOut" section="global"}</div>
                                {/if}
                            </div>
                        </div>
                    {/if}
                </div>
            {/if}


            <div class="row">

				{if $Einstellungen.artikeldetails.produktfrage_abfragen_firma !== 'N'}
					<div class="col-12 col-md-6">
						<div class="form-group float-label-control {if isset($fehlendeAngaben_fragezumprodukt.firma) && $fehlendeAngaben_fragezumprodukt.firma > 0}has-error{/if}{if $Einstellungen.artikeldetails.produktfrage_abfragen_firma === 'Y'} required{/if}">
							<label class="control-label" for="company">{lang key="firm" section="account data"}</label>
							<input class="form-control" type="text" name="firma" value="{if isset($Anfrage)}{$Anfrage->cFirma}{/if}" id="company"{if $Einstellungen.artikeldetails.produktfrage_abfragen_firma === 'Y'} required{/if}>
							{if isset($fehlendeAngaben_fragezumprodukt.firma) && $fehlendeAngaben_fragezumprodukt.firma > 0}
								<div class="form-error-msg text-danger"> {lang key="fillOut" section="global"}</div>
							{/if}
						</div>
					</div>
				{/if}
                <div class="col-12 col-md-6">
                    <div class="form-group float-label-control {if isset($fehlendeAngaben_fragezumprodukt.email) && $fehlendeAngaben_fragezumprodukt.email > 0}has-error{/if} required">
                        <label class="control-label" for="question_email">{lang key="email" section="account data"}</label>
                        <input class="form-control" type="email" name="email" value="{if isset($Anfrage)}{$Anfrage->cMail}{/if}" id="question_email" required>
                        {if isset($fehlendeAngaben_fragezumprodukt.email) && $fehlendeAngaben_fragezumprodukt.email > 0}
                            <div class="form-error-msg text-danger"> {if $fehlendeAngaben_fragezumprodukt.email == 1}{lang key="fillOut" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.email == 2}{lang key="invalidEmail" section="global"}{elseif $fehlendeAngaben_fragezumprodukt.email==3}{lang key="blockedEmail" section="global"}{/if}</div>
                        {/if}
                    </div>
                </div>
            </div>

            {if $Einstellungen.artikeldetails.produktfrage_abfragen_tel !== 'N' || $Einstellungen.artikeldetails.produktfrage_abfragen_mobil !== 'N'}
                <div class="row">
                    {if $Einstellungen.artikeldetails.produktfrage_abfragen_tel !== 'N'}
                        <div class="col-12 col-md-6">
                            <div class="form-group float-label-control {if isset($fehlendeAngaben_fragezumprodukt.tel) && $fehlendeAngaben_fragezumprodukt.tel > 0}has-error{/if}{if $Einstellungen.artikeldetails.produktfrage_abfragen_tel === 'Y'} required{/if}">
                                <label class="control-label" for="tel">{lang key="tel" section="account data"}</label>
                                <input class="form-control" type="text" name="tel" value="{if isset($Anfrage)}{$Anfrage->cTel}{/if}" id="tel"{if $Einstellungen.artikeldetails.produktfrage_abfragen_tel === 'Y'} required{/if}>
                                {if isset($fehlendeAngaben_fragezumprodukt.tel) && $fehlendeAngaben_fragezumprodukt.tel > 0}
                                    <div class="form-error-msg text-danger">
                                        {if $fehlendeAngaben_fragezumprodukt.tel == 1}
                                            {lang key="fillOut" section="global"}
                                        {elseif $fehlendeAngaben_fragezumprodukt.tel == 2}
                                            {lang key="invalidTel" section="global"}
                                        {/if}
                                    </div>
                                {/if}
                            </div>
                        </div>
                    {/if}

                    {if $Einstellungen.artikeldetails.produktfrage_abfragen_mobil !== 'N'}
                        <div class="col-12 col-md-6">
                            <div class="form-group float-label-control{if isset($fehlendeAngaben_fragezumprodukt.mobil) && $fehlendeAngaben_fragezumprodukt.mobil > 0} has-error{/if}{if $Einstellungen.artikeldetails.produktfrage_abfragen_mobil === 'Y'} required{/if}">
                                <label class="control-label" for="mobile">{lang key="mobile" section="account data"}</label>
                                <input class="form-control" type="text" name="mobil" value="{if isset($Anfrage)}{$Anfrage->cMobil}{/if}" id="mobile"{if $Einstellungen.artikeldetails.produktfrage_abfragen_mobil === 'Y'} required{/if}>
                                {if isset($fehlendeAngaben_fragezumprodukt.mobil) && $fehlendeAngaben_fragezumprodukt.mobil > 0}
                                    <div class="form-error-msg text-danger">
                                        {if $fehlendeAngaben_fragezumprodukt.mobil == 1}
                                            {lang key="fillOut" section="global"}
                                        {elseif $fehlendeAngaben_fragezumprodukt.mobil == 2}
                                            {lang key="invalidTel" section="global"}
                                        {/if}
                                    </div>
                                {/if}
                            </div>
                        </div>
                    {/if}
                </div>
            {/if}

            {if $Einstellungen.artikeldetails.produktfrage_abfragen_fax !== 'N'}
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group float-label-control{if isset($fehlendeAngaben_fragezumprodukt.fax) && $fehlendeAngaben_fragezumprodukt.fax > 0} has-error{/if}{if $Einstellungen.artikeldetails.produktfrage_abfragen_fax === 'Y'} required{/if}">
                            <label class="control-label" for="fax">{lang key="fax" section="account data"}</label>
                            <input class="form-control" type="text" name="fax" value="{if isset($Anfrage)}{$Anfrage->cFax}{/if}" id="fax"{if $Einstellungen.artikeldetails.produktfrage_abfragen_fax === 'Y'} required{/if}>
                            {if isset($fehlendeAngaben_fragezumprodukt.fax) && $fehlendeAngaben_fragezumprodukt.fax > 0}
                                <div class="form-error-msg text-danger">
                                    {if $fehlendeAngaben_fragezumprodukt.fax == 1}
                                        {lang key="fillOut" section="global"}
                                    {elseif $fehlendeAngaben_fragezumprodukt.fax == 2}
                                        {lang key="invalidTel" section="global"}
                                    {/if}
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            {/if}
        </fieldset>

        <fieldset class="panel mb-sm">
            <span class="block h5">{lang key="productQuestion" section="productDetails"}</span>
            <div class="form-group float-label-control {if isset($fehlendeAngaben_fragezumprodukt.nachricht) && $fehlendeAngaben_fragezumprodukt.nachricht > 0}has-error{/if} required">
                <label class="control-label" for="question">{lang key="question" section="productDetails"}</label>
                <textarea class="form-control" name="nachricht" id="question" cols="80" rows="8" required>{if isset($Anfrage)}{$Anfrage->cNachricht}{/if}</textarea>
                {if isset($fehlendeAngaben_fragezumprodukt.nachricht) && $fehlendeAngaben_fragezumprodukt.nachricht > 0}
                    <div class="form-error-msg text-danger"> {if $fehlendeAngaben_fragezumprodukt.nachricht > 0}{lang key="fillOut" section="global"}{/if}</div>
                {/if}
            </div>

            {if isset($fehlendeAngaben_fragezumprodukt)}
                {include file='snippets/checkbox.tpl' nAnzeigeOrt=$smarty.const.CHECKBOX_ORT_FRAGE_ZUM_PRODUKT cPlausi_arr=$fehlendeAngaben_fragezumprodukt cPost_arr=null}
            {else}
                {include file='snippets/checkbox.tpl' nAnzeigeOrt=$smarty.const.CHECKBOX_ORT_FRAGE_ZUM_PRODUKT cPlausi_arr=null cPost_arr=null}
            {/if}

        </fieldset>
        {if (!isset($smarty.session.bAnti_spam_already_checked) || $smarty.session.bAnti_spam_already_checked !== true) &&
            isset($Einstellungen.artikeldetails.produktfrage_abfragen_captcha) && $Einstellungen.artikeldetails.produktfrage_abfragen_captcha !== 'N' && empty($smarty.session.Kunde->kKunde)}
            
            <div class="row">
                <div class="col-12 col-md-12{if !empty($fehlendeAngaben_fragezumprodukt.captcha)} has-error{/if}">
                    {captchaMarkup getBody=true}
                </div>
            </div>
        {/if}

        {if $Einstellungen.artikeldetails.artikeldetails_fragezumprodukt_anzeigen === 'P' && isset($oSpezialseiten_arr[$smarty.const.LINKTYP_DATENSCHUTZ])}
            <p class="privacy text-muted small">
                <a href="{$oSpezialseiten_arr[$smarty.const.LINKTYP_DATENSCHUTZ]->getURL()}" class="popup">{$oSpezialseiten_arr[12]->cName}</a>
            </p>
        {/if}
        <input type="hidden" name="a" value="{$Artikel->kArtikel}" />
        <input type="hidden" name="show" value="1" />
        <input type="hidden" name="fragezumprodukt" value="1" />
        <button type="submit" value="{lang key="sendQuestion" section="productDetails"}" class="btn btn-primary btn-lg btn-block" >{lang key="sendQuestion" section="productDetails"}</button>
    </form>
</div>
{/block}