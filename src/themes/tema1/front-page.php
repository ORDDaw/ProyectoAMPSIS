<?php get_header(); ?>

<main class="hero">
  <section class="card">
    <span class="badge">WebFusion Digital S.L.</span>
    <h1>Examen</h1>
    <p>
      Esta pagina principal se actualiza desde GitHub mediante un contenedor Git,
      Docker Compose y Vagrant. Para publicar cambios solo hay que subirlos al
      repositorio y ejecutar <code>vagrant provision</code>.
    </p>

    <div class="grid">
      <article class="feature">
        <strong>GitHub</strong>
        Control de versiones y origen del codigo PHP de la pagina principal.
      </article>
      <article class="feature">
        <strong>Vagrant</strong>
        Crea una maquina virtual Ubuntu reproducible para cualquier desarrollador.
      </article>
      <article class="feature">
        <strong>Docker Compose</strong>
        Despliega WordPress, MySQL, WP-CLI y el contenedor de sincronizacion Git.
      </article>
    </div>
    <div>
      Hecho por Ismael Cuadrado, Óscar Roldán y Daniel Antolín
    </div>
  </section>
</main>

<?php get_footer(); ?>
