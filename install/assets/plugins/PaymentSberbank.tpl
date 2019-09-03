//<?php
/**
 * Payment Sberbank
 *
 * Sberbank payments processing
 *
 * @category    plugin
 * @version     0.1.3
 * @author      mnoskov
 * @internal    @events OnRegisterPayments,OnBeforeOrderSending
 * @internal    @properties &title=Название;text; &token=Токен;text; &login=Логин;text; &password=Пароль;text; &debug=Отладка запросов;list;Нет==0||Да==1;0 &test=Тестовый доступ;list;Нет==0||Да==1;1
 * @internal    @modx_category Commerce
 * @internal    @installset base
*/

if (!empty($modx->commerce)) {
    switch ($modx->Event->name) {
        case 'OnRegisterPayments': {
            $class = new \Commerce\Payments\SberbankPayment($modx, $params);

            if (empty($params['title'])) {
                $lang = $modx->commerce->getUserLanguage('sberbank');
                $params['title'] = $lang['sberbank.caption'];
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

        case 'OnManagerBeforeOrderRender': {
            if (isset($params['groups']['payment_delivery']) && !empty($order['fields']['payment_method']) && $order['fields']['payment_method'] == 'sberbank') {
                $lang = $modx->commerce->getUserLanguage('sberbank');

                $params['groups']['payment_delivery']['fields']['payment_link'] = [
                    'title'   => $lang['sberbank.link_caption'],
                    'content' => function($data) use ($modx) {
                        return $modx->commerce->loadProcessor()->populateOrderPaymentLink('@CODE:<a href="[+link+]" target="_blank">[+link+]</a>');
                    },
                    'sort' => 50,
                ];
            }

            break;
        }
    }
}
