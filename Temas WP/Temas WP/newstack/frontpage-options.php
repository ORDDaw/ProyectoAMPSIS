<?php

/**
 * Option Panel
 *
 * @package Newstack
 */


function newstack_customize_register($wp_customize) {

    $newsup_default = newstack_get_default_theme_options();

    //section title
    $wp_customize->add_setting('editior_post_section',
        array(
            'sanitize_callback' => 'sanitize_text_field',
        )
    );
    $wp_customize->add_control(
        new newsup_Section_Title(
            $wp_customize,
            'editior_post_section',
            array(
                'label'             => esc_html__( 'Editor Post Section', 'newstack' ),
                'section'           => 'frontpage_main_banner_section_settings',
                'priority'          => 40,
                'active_callback' => 'newsup_main_banner_section_status'
            )
        )
    );

    // Setting - drop down category for slider.
    $wp_customize->add_setting('select_editor_news_category',
        array(
            'default' => $newsup_default['select_editor_news_category'],
            'capability' => 'edit_theme_options',
            'sanitize_callback' => 'absint',
        )
    );
    $wp_customize->add_control(new Newsup_Dropdown_Taxonomies_Control($wp_customize, 'select_editor_news_category',
        array(
            'label' => esc_html__('Category', 'newstack'),
            'description' => esc_html__('Select category for Editor 2 Post', 'newstack'),
            'section' => 'frontpage_main_banner_section_settings',
            'type' => 'dropdown-taxonomies',
            'taxonomy' => 'category',
            'priority' => 60,
            'active_callback' => 'newsup_main_banner_section_status'
        )
    ));
}
add_action('customize_register', 'newstack_customize_register');
