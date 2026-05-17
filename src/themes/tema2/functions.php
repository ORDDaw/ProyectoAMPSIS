<?php

function tema_corporativo_enqueue_styles() {
    wp_enqueue_style('tema-corporativo-style', get_stylesheet_uri(), array(), '1.0');
}
add_action('wp_enqueue_scripts', 'tema_corporativo_enqueue_styles');
