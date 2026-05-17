<?php

function tema_minimalista_enqueue_styles() {
    wp_enqueue_style('tema-minimalista-style', get_stylesheet_uri(), array(), '1.0');
}
add_action('wp_enqueue_scripts', 'tema_minimalista_enqueue_styles');
