//<?php
/**
 * Payment Sberbank
 *
 * Sberbank payments processing
 *
 * @category    plugin
 * @version     0.1.2
 * @author      mnoskov
 * @internal    @events OnRegisterPayments,OnBeforeOrderSending
 * @internal    @properties &title=Название;text; &token=Токен;text; &login=Логин;text; &password=Пароль;text; &debug=Отладка;list;Нет==0||Да==1;0 
 * @internal    @modx_category Commerce
 * @internal    @installset base
*/

if (!empty($modx->commerce)) {
    switch ($modx->Event->name) {
        case 'OnRegisterPayments': {
            $class = new \Commerce\Payments\SberbankPayment($modx, $params);

            if (empty($params['title'])) {
                $lang = $modx->commerce->getUserLanguage('payments');
                $params['title'] = $lang['payments.sberbank_title'];
            }

            $modx->commerce->registerPayment('sberbank', $params['title'], $class);
            break;
        }

        case 'OnBeforeOrderSending': {
            if (!empty($order['fields']['payment_method']) && $order['fields']['payment_method'] == 'sberbank') {
                $FL->setPlaceholder('extra', $FL->getPlaceholder('extra', '') . $modx->commerce->loadProcessor()->populateOrderPaymentLink());
            }

            break;
        }
    }
}
