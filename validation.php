<?php
/*
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
*  @version  Release: $Revision: 7040 $
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

include(dirname(__FILE__).'/../../config/config.inc.php');
include(dirname(__FILE__).'/../../init.php');
include(dirname(__FILE__).'/stripejs.php');

if (!defined('_PS_VERSION_'))
	exit;


/* Check that the Stripe's module is active and that we have the token */
$stripe = new StripeJs();
$context = Context::getContext();
if ($stripe->active && Tools::getIsset('stripeToken')) {
 	$stripe->processPayment(Tools::getValue('stripeToken'));
}
else {
	$context->cookie->__set("stripe_error", 'There was a problem with your payment');
	$controller = Configuration::get('PS_ORDER_PROCESS_TYPE') ? 'order-opc.php' : 'order.php';
	$location = $context->link->getPageLink($controller).(strpos($controller, '?') !== false ? '&' : '?').'step=3#stripe_error';
	header('Location: '.$location);
}