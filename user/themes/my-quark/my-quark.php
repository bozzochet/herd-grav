<?php
    namespace Grav\Theme;

    use Grav\Common\Grav;
    use Grav\Common\Theme;

    class MyQuark extends Quark {
        // Access plugin events in this class
        public static function getSubscribedEvents() {
            return [
    	        'onTwigLoader' => ['onTwigLoader', 10]
            ];
        }

        public function onTwigLoader() {
            parent::onTwigLoader();

            // add quark theme as namespace to twig
            $quark_path = Grav::instance()['locator']->findResource('themes://quark');
            $this->grav['twig']->addPath($quark_path . DIRECTORY_SEPARATOR . 'templates', 'quark');
        }
    }
