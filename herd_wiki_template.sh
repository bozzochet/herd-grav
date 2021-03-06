#!/bin/bash

echo "---"
if [[ $0 == *"herd_wiki_template_choice.sh"* ]]
then
    echo "title: 'HERD Wiki'"
else
    echo "title: 'HERD Wiki - Version $1'"
fi
#echo "sitemap:"
#echo "    changefreq: monthly"
echo "body_classes: 'header-dark header-transparent'"
#echo "hero_classes: 'text-light title-h1h2 overlay-dark-gradient hero-large parallax'"
echo "hero_classes: 'text-light title-h1h1 overlay-dark-gradient hero-tiny'"
echo "hero_image: mountain_short.jpg"
echo "header_image_height: 10"
#echo "custom: 'new thing'"
#echo "blog_url: '/blog'"
echo "item_type: 'wiki'"
if [[ ! $0 == *"herd_wiki_template_choice.sh"* ]]
then
    echo "show_sidebar: true"
    echo "sidebar_root: $2"
fi
echo "hero_noarrow: true"
#echo "content:"
#echo "    items:"
#echo "        - '@self.children'"
#echo "    limit: 6"
#echo "    order:"
#echo "        by: date"
#echo "        dir: desc"
#echo "    pagination: false"
#echo "    url_taxonomy_filters: false"
#echo "feed:"
#echo "    description: 'Sample Blog Description'"
#echo "    limit: 10"
#echo "pagination: true"
echo "process:"
echo "    markdown: true"
echo "    twig: false"
echo "twig_first: false"
echo "---"
echo ""

if [[ $0 == *"herd_wiki_template_choice.sh"* ]]
then
    echo ""
    echo "# HERD-SW Wiki versions"
    echo ""
fi
