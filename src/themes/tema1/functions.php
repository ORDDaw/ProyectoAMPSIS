<?php
function webfusion_home_enqueue_styles() {
    wp_enqueue_style('webfusion-home-style', get_stylesheet_uri(), array(), '1.0');
}
add_action('wp_enqueue_scripts', 'webfusion_home_enqueue_styles');
