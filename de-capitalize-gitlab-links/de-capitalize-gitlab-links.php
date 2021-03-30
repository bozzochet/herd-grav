<?php
namespace Grav\Plugin;

use Composer\Autoload\ClassLoader;
use Grav\Common\Plugin;
use Grav\Common\Uri;

/**
 * Class DeCapitalizeGitlabLinksPlugin
 * @package Grav\Plugin
 */
class DeCapitalizeGitlabLinksPlugin extends Plugin
{
    /**
     * @return array
     *
     * The getSubscribedEvents() gives the core a list of events
     *     that the plugin wants to listen to. The key of each
     *     array section is the event that the plugin listens to
     *     and the value (in the form of an array) contains the
     *     callable (or function) as well as the priority. The
     *     higher the number the higher the priority.
     */
    public static function getSubscribedEvents(): array
    {
        return [
            'onPluginsInitialized' => [
                ['autoload', 100000], // TODO: Remove when plugin requires Grav >=1.7
                ['onPluginsInitialized', 0]
            ]
        ];
    }

    /**
    * Composer autoload.
    *is
    * @return ClassLoader
    */
    public function autoload(): ClassLoader
    {
        return require __DIR__ . '/vendor/autoload.php';
    }

    /**
     * Initialize the plugin
     */
    public function onPluginsInitialized(): void
    {
        // Don't proceed if we are in the admin plugin
        if ($this->isAdmin()) {
            return;
        }

        // Enable the main events we are interested in
        $this->enable([
            // Put your main events here
	    'onTwigInitialized' => ['onTwigInitialized', 0]
        ]);
    }

    /**
     * @param Event $e
     */
    public function onTwigInitialized()
    {
        $this->grav['twig']->twig()->addFilter(
            new \Twig_SimpleFilter('processmarkdownlinks', [$this, 'ProcessMarkdownLinks'])
        );
	$this->grav['twig']->twig()->addFilter(
            new \Twig_SimpleFilter('processhtmllinks', [$this, 'ProcessHTMLLinks'])
        );
	$this->grav['twig']->twig()->addFilter(
            new \Twig_SimpleFilter('removetoc', [$this, 'RemoveGitLabTOC'])
        );
	$this->grav['twig']->twig()->addFilter(
            new \Twig_SimpleFilter('containstoc', [$this, 'CheckGitLabTOC'])
        );
	$this->grav['twig']->twig()->addFilter(
            new \Twig_SimpleFilter('chunker', [$this, 'chunkString'])
        );
    }

    /**
     * Proces GitLab Markdown URLs
     */
    public function ProcessMarkdownLinks($string)
    {
    	$finalStr = preg_replace_callback('/\[([^\]]+)\]\(([^\)]+)\)/', function ($matches) {
		      $thisurl = $_SERVER['REQUEST_URI'];
		      $lastdir = pathinfo($thisurl)['filename'];
		      $onlythis = str_replace(basename($thisurl), "", strtolower(str_replace(' ','-',$matches[2])));
		      $prefixpath = str_replace($lastdir, "", $thisurl);
		      $newurl = $prefixpath.$onlythis;
		      $rooturl = $this->grav['uri']->rootUrl(false);
		      $newurl = str_replace($rooturl, "", $newurl);
//		      return '['.$matches[1].']('.strtolower(str_replace(' ','-',$matches[2])).')';#original
//		      return '['.$newurl.']('.$newurl.')';#only to inspect
//		      return '['.$matches[1].'mdlinkmodified]('.$newurl.')';
		      return '['.$matches[1].']('.$newurl.')';
		  }, $string);
//	$finalStr = preg_replace_callback('/\[([^\]]+)\]\(([^\)]+)\)/', function ($matches) { return '['.$matches[1].'mdlinkmodified]('.strtolower(str_replace(' ','-',$matches[2])).')'; }, $string);
//	$finalStr = preg_replace_callback('/\[([^\]]+)\]\(([^\)]+)\)/', function ($matches) { return '<a href="'.strtolower(str_replace(' ','-',$matches[2])).'">fava'.$matches[1].'</a>'; }, $string);
//        return $finalStr.'_markdownlinksprocessed';
        return $finalStr;
    }

    /**
     * Proces GitLab HTML URLs
     */
    public function ProcessHTMLLinks($string)
    {
	$finalStr = $string;
	// Original PHP code by Chirp Internet: www.chirpinternet.eu
        // Please acknowledge use of this code by including this header.
	$regexp = "<a\s[^>]*href=(\"??)([^\" >]*?)\\1[^>]*>(.*)<\/a>";
//	if(preg_match_all("/$regexp/siU", $string, $matches)) {
	if(preg_match_all("/$regexp/siU", $string, $matches, PREG_SET_ORDER)) {
	  // $matches[2] = array of link addresses
          // $matches[3] = array of link text - including HTML code
	  foreach($matches as $match) {
	    $address = $match[2];
	    $addressnomd = preg_replace('/.md$/', '', $address);
	    $addressnomdnocapnosp = strtolower(str_replace(' ','-',$addressnomd));
	    $finalStr = str_replace($address, $addressnomdnocapnosp, $finalStr);
//	    $finalStr = str_replace($match[3], $match[3].'htmllinkmodified', $finalStr);
	    $finalStr = str_replace($match[3], $match[3], $finalStr);
//	    // $match[2] = link address
//	    // $match[3] = link text
	  }
	}
//        return $finalStr.'_htmllinksprocessed';
        return $finalStr;
    }

    /**
     * Remove the GitLab [[TOC]]
     */
    public function RemoveGitLabTOC($string)
    {
    	$toc = '~[[TOC]]~';
	$tmpStr = preg_replace(preg_quote($toc), "", $string);
	$tocem = '~[[<em>TOC</em>]]~';
	$finalStr = preg_replace(preg_quote($tocem), "", $tmpStr);
        return $finalStr;
    }

    /**
     * Remove the GitLab [[TOC]]
     */
    public function CheckGitLabTOC($string)
    {
        $toc = '~[[TOC]]~';
	$tocem = '~[[<em>TOC</em>]]~';
	if (preg_match(preg_quote($toc), $string)) return true;
	if (preg_match(preg_quote($tocem), $string)) return true;
        return false;
    }

    /**
     * Break a string up into chunks
     */
    public function chunkString($string, $chunksize = 4, $delimiter = '-')
    {
        return (trim(chunk_split($string, $chunksize, $delimiter), $delimiter));
    }
    
}
