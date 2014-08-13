{*
* 2007-2013 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2013 PrestaShop SA
*  @version  Release: $Revision: 6664 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}


<div class="payment_module {if $stripe_ps_version < '1.5'}stripe-payment-15{/if}{if $stripe_ps_version > '1.5'}stripe-payment-16{/if}">
	<h3 class="stripe_title">{l s='Pay by credit / debit card' mod='stripejs'} <img alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/secure-icon.png" /></h3>
	{* This form will be displayed only if a previous credit card was saved *}
	{if isset($stripe_save_tokens_ask) && $stripe_save_tokens_ask && isset($stripe_credit_card)}
	<form action="{$validation_url|escape:htmlall:'UTF-8'}" method="POST" id="stripe-payment-form-cc">
		<p>{l s='Pay with my saved Credit card (ending in' mod='stripejs'} {$stripe_credit_card|escape:html:'UTF-8'}{l s=')' mod='stripejs'}
		<input type="hidden" name="stripe_save_token" value="1" />
		<input type="hidden" name="stripeToken" value="0" />
		<button type="submit" class="stripe-submit-button-cc">{l s='Submit Payment' mod='stripejs'}</button></p>
		<p><a id="stripe-replace-card">{l s='Replace this card with a new one' mod='stripejs'}</a> | <a id="stripe-delete-card" onclick="return confirm('{l s='Do you really want to delete this card?' mod='stripejs'}');">{l s='Delete this card' mod='stripejs'}</a></p>
	</form>
	{/if}
	{* Classic Credit card form *}
	<div id="stripe-ajax-loader"><img src="{$module_dir|escape:htmlall:'UTF-8'}img/ajax-loader.gif" alt="" /> {l s='Transaction in progress, please wait.' mod='stripejs'}</div>
	<form action="{$validation_url|escape:htmlall:'UTF-8'}" method="POST" id="stripe-payment-form"{if isset($stripe_save_tokens_ask) && $stripe_save_tokens_ask && isset($stripe_credit_card)} style="display: none;"{/if}>
		<div class="stripe-payment-errors">{if isset($stripe_error)}{$stripe_error|escape:htmlall:'UTF-8'}{/if}</div>

			<a name="stripe_error" style="display:none"></a>
		<div class="stripe-card-deleted"></div>
		<label>{l s='Card Number' mod='stripejs'}</label><br />
		<input type="text" size="20" autocomplete="off" class="stripe-card-number" />
		
			<img class="cc-icon disable" rel="Visa" alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/cc-visa.png" />
			<img class="cc-icon disable" rel="MasterCard" alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/cc-mastercard.png" />
			<img class="cc-icon disable" rel="Discover" alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/cc-discover.png" />
			<img class="cc-icon disable" rel="American Express" alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/cc-amex.png" />
			<img class="cc-icon disable" rel="JCB" alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/cc-jcb.png" />
			<img class="cc-icon disable" rel="Diners Club" alt="" src="{$module_dir|escape:htmlall:'UTF-8'}img/cc-diners.png" />
		
		<br />
		
		<div class="block-left">
			<label>{l s='CVC' mod='stripejs'}</label><br />
			<input type="text" size="4" autocomplete="off" class="stripe-card-cvc" />
			<a href="javascript:void(0)" class="stripe-card-cvc-info" style="border: none;">
				{l s='What\'s this?' mod='stripejs'}
				<div class="cvc-info">
				{l s='The CVC (Card Validation Code) is a 3 or 4 digit code on the reverse side of Visa, MasterCard and Discover cards and on the front of American Express cards.' mod='stripejs'}
				</div>
			</a>
		</div>
		<div class="clear"></div>
		<label>{l s='Expiration (MM/YYYY)' mod='stripejs'}</label><br />
		<select id="month" name="month" class="stripe-card-expiry-month">
			<option value="01">{l s='January' mod='stripejs'}</option>
			<option value="02">{l s='February' mod='stripejs'}</option>
			<option value="03">{l s='March' mod='stripejs'}</option>
			<option value="04">{l s='April' mod='stripejs'}</option>
			<option value="05">{l s='May' mod='stripejs'}</option>
			<option value="06">{l s='June' mod='stripejs'}</option>
			<option value="07">{l s='July' mod='stripejs'}</option>
			<option value="08">{l s='August' mod='stripejs'}</option>
			<option value="09">{l s='September' mod='stripejs'}</option>
			<option value="10">{l s='October' mod='stripejs'}</option>
			<option value="11">{l s='November' mod='stripejs'}</option>
			<option value="12">{l s='December' mod='stripejs'}</option>
		</select>
		<span> / </span>
		<select id="year" name="year" class="stripe-card-expiry-year">
			{assign var='startyear' value=$smarty.now|date_format:"%Y"}
            		{assign var='endyear' value=($smarty.now|date_format:"%Y" + 10)}

            		{for $i=$startyear to $endyear}
                		<option value="{$i}">{$i}</option>
            		{/for}
        </select>
		<br />
		{if isset($stripe_save_tokens_ask)}
			<input type="checkbox" name="stripe_save_token" id="stripe_save_token" value="1" />
			<label class="lowercase" for="stripe_save_token">{l s='Store this credit card info for later use' mod='stripejs'}</label>
			<br />
		{/if}
		<button type="submit" class="stripe-submit-button">{l s='Submit Payment' mod='stripejs'}</button>
	</form>
	<div id="stripe-translations">
		<span id="stripe-wrong-cvc">{l s='Wrong CVC.' mod='stripejs'}</span>
		<span id="stripe-wrong-expiry">{l s='Wrong Credit Card Expiry date.' mod='stripejs'}</span>
		<span id="stripe-wrong-card">{l s='Wrong Credit Card number.' mod='stripejs'}</span>
		<span id="stripe-please-fix">{l s='Please fix it and submit your payment again.' mod='stripejs'}</span>
		<span id="stripe-card-del">{l s='Your Credit Card has been successfully deleted, please enter a new Credit Card:' mod='stripejs'}</span>
		<span id="stripe-card-del-error">{l s='An error occured while trying to delete this Credit card. Please contact us.' mod='stripejs'}</span>
	</div>
</div>
