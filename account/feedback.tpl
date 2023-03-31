{block name='account-feedback'}
<h1 class="h2 mb-spacer mb-small">{lang key='allRatings'}</h1>

{if JTL\Session\Frontend::getCustomer()->getID() === 0}
    <div class="alert alert-danger">{lang key='loginFirst' section='product rating'}</div>
{elseif $bewertungen|count == 0}
    <div class="alert alert-danger">{lang key='no feedback' section='product rating'}</div>
{else}
        {foreach $bewertungen as $Bewertung}
        <div class="card review">
            <div class="card-header">
                <div class="dpflex-j-between">
                    <div class="block">
                        <strong>{$Bewertung->cTitel}</strong>
                        <small class="text-muted block">{$Bewertung->dDatum}</small>
                    </div>
                    <span class="right">{include file='productdetails/rating.tpl' stars=$Bewertung->nSterne}</span>
                </div>
            </div>
            <div class="card-body">
                <div class="dpflex-j-between mb-xs">
                    {$Bewertung->cText}
                    <div class="right">
                        <a title="{lang key='edit' section='product rating'}" href="{get_static_route id='bewertung.php'}?a={$Bewertung->kArtikel}&bfa=1&token={$smarty.session.jtl_token}"} class="btn btn-ic">
                            <span class="img-ct icon">
                                <svg>
                                  <use xlink:href="{$ShopURL}/{if empty($parentTemplateDir)}{$currentTemplateDir}{else}{$parentTemplateDir}{/if}img/icons/icons.svg?v={$nTemplateVersion}#icon-edit"></use>
                                </svg>
                            </span>
                        </a>
                    </div>
                </div>
                    {if !empty($Bewertung->cAntwort)}
                        <div class="review card mb-xs">
                            <div class="panel">
                                <strong>{lang key='reply' section='product rating'} {$cShopName}:</strong>
                                <hr class="hr-sm">
                                <div class="answer">
                                    {$Bewertung->cAntwort}
                                    <small class="block text-muted">{$Bewertung->dAntwortDatum}</small>
                                </div>
                            </div>
                        </div>
                    {/if}
                <div class="small">
                    {if !empty($Bewertung->fGuthabenBonus)}
                        {lang key='balance bonus' section='product rating'}: {$Bewertung->fGuthabenBonusLocalized} | 
                    {/if}
                    {if $Bewertung->nAktiv == 1}
                        {lang key='feedback activated' section='product rating'}
                    {else}
                        {lang key='feedback deactivated' section='product rating'}
                    {/if}
                </div>
            </div>
        </div>
        <hr class="invisible hr-sm">
        {/foreach}
{/if}
{/block}