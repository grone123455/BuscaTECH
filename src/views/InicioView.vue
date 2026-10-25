<template>
  <section class="hero">
    <div class="hero-content">
      <span class="eyebrow">ORGANIZÁ · ENCONTRÁ · TRABAJÁ</span>

      <h1>Encontrá lo que necesitás.<br /><span>Cuando lo necesitás.</span></h1>

      <p class="hero-description">
        Consultá herramientas, materiales y equipos del pañol escolar
        y encontrá su ubicación sin perder tiempo.
      </p>

      <div class="hero-actions">
        <RouterLink to="/catalogo" class="button button-primary">
          Explorar catálogo →
        </RouterLink>
        <RouterLink to="/registro" class="button button-secondary">
          Crear cuenta
        </RouterLink>
      </div>

      <div class="hero-note">
        <span class="status-dot"></span>
        Toda la información del pañol en un solo lugar
      </div>
    </div>

    <div class="hero-visual">
      <div class="visual-glow"></div>
      <div class="tool-card">
        <div class="tool-card-top">
          <span class="tool-symbol">⌕</span>
          <span class="tool-label">BUSCAR EN EL PAÑOL</span>
        </div>
        <div class="fake-search">¿Qué herramienta necesitás?</div>

        <div class="location-preview">
          <div class="location-icon">⌖</div>
          <div>
            <strong>Ubicación del objeto</strong>
            <p>Sector · Estante · Armario</p>
          </div>
          <span class="location-arrow">↗</span>
        </div>

        <div class="visual-bottom">
          <span>BUSCATECH</span>
          <span>ORDEN Y PRECISIÓN</span>
        </div>
      </div>
      <div class="floating-label"><span>✓</span> Ubicación fácil de consultar</div>
    </div>
  </section>

  <section class="features">
    <div class="section-heading">
      <span class="eyebrow">UNA HERRAMIENTA PARA TU ESCUELA</span>
      <h2>El pañol, más organizado.</h2>
      <p>Accedé a la información que necesitás para tus actividades prácticas.</p>
    </div>

    <div class="feature-grid">
      <article class="feature-card">
        <div class="feature-icon">⌕</div>
        <h3>Buscá por nombre</h3>
        <p>Encontrá rápidamente una herramienta, material o equipo.</p>
      </article>

      <article class="feature-card">
        <div class="feature-icon">▦</div>
        <h3>Filtrá por especialidad</h3>
        <p>Organizá la búsqueda por mecánica, electricidad y otras áreas.</p>
      </article>

      <article class="feature-card">
        <div class="feature-icon">⌖</div>
        <h3>Conocé su ubicación</h3>
        <p>Consultá el sector, estante o armario donde está guardado cada objeto.</p>
      </article>
    </div>
  </section>
</template>
