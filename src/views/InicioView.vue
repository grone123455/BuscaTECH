<template>
  <div class="home-page">
    <section class="home-hero" aria-labelledby="home-title">
      <div class="home-copy">
        <p class="eyebrow">EEST N.º 1 <span class="eyebrow-divider">/</span> ESTEBAN ECHEVERRÍA</p>
        <h1 id="home-title" class="home-title">Cada herramienta.<br /><em>En su lugar.</em></h1>
        <p class="home-description">Una forma más simple de encontrar y organizar las herramientas, materiales y equipos del pañol escolar.</p>
        <div class="hero-actions">
          <RouterLink to="/catalogo" class="button button-primary">Explorar el catálogo
            <svg class="button-arrow" viewBox="0 0 16 16" aria-hidden="true"><path d="M2.5 8h10m-4-4 4 4-4 4" /></svg>
          </RouterLink>
          <RouterLink to="/registro" class="button button-secondary">Crear una cuenta</RouterLink>
        </div>
        <div class="home-footnote">
          <svg viewBox="0 0 20 20" aria-hidden="true"><path d="m5 10 3.1 3.1L15 6.5"/><circle cx="10" cy="10" r="7.2"/></svg>
          Diseñado para el día a día del taller técnico
        </div>
      </div>

      <div class="home-visual" aria-label="Esquema ilustrativo de los niveles de ubicación de un objeto">
        <div class="workshop-card">
          <div class="workshop-card-head">
            <div class="workshop-label">
              <span class="workshop-icon" aria-hidden="true"><svg viewBox="0 0 20 20"><path d="M3.5 16.5V5.2L10 2l6.5 3.2v11.3M2 16.5h16M7 7.2h.01M10 7.2h.01M13 7.2h.01M7 10.2h.01M10 10.2h.01M13 10.2h.01M8 16.5v-3.2h4v3.2"/></svg></span>
              <span><strong>Organización del pañol</strong><small>Una ubicación clara para cada ficha</small></span>
            </div>
            <span class="workshop-status">ESQUEMA</span>
          </div>
          <h2 class="diagram-heading">Ubicación, paso a paso</h2>
          <p class="diagram-description">La información se ordena en niveles fáciles de consultar.</p>
          <div class="location-diagram" aria-hidden="true">
            <div class="location-level"><span class="level-index">01</span><strong>Sector</strong><small>Área del pañol</small><span class="level-mark"></span></div>
            <div class="location-level"><span class="level-index">02</span><strong>Estante</strong><small>Dentro del sector</small><span class="level-mark gold"></span></div>
            <div class="location-level"><span class="level-index">03</span><strong>Armario o cajón</strong><small>Ubicación precisa</small><span class="level-mark"></span></div>
          </div>
          <div class="card-caption"><svg viewBox="0 0 16 16" aria-hidden="true"><path d="M8 1.8 13 4v3.4c0 3-2 5.1-5 6.8-3-1.7-5-3.8-5-6.8V4l5-2.2Z"/><path d="m5.8 8 1.5 1.5 3-3"/></svg>Esquema de referencia · sin objetos de ejemplo</div>
        </div>
      </div>
    </section>

    <section class="home-section" aria-labelledby="home-features-title">
      <div class="home-section-inner">
        <div class="section-intro">
          <div><p class="eyebrow">HECHO PARA EL TALLER</p><h2 id="home-features-title">Menos vueltas. Más precisión.</h2></div>
          <p>La información del pañol, organizada para que cada búsqueda sea directa y cada ubicación fácil de entender.</p>
        </div>
        <div class="feature-grid">
          <article class="feature-card">
            <div class="feature-card-top"><span class="feature-icon" aria-hidden="true"><svg viewBox="0 0 20 20"><circle cx="8.5" cy="8.5" r="5.5"/><path d="m12.5 12.5 4 4"/></svg></span><h3>Encontrá por nombre</h3></div>
            <p>Buscá herramientas, materiales y equipos desde un catálogo central.</p>
          </article>
          <article class="feature-card">
            <div class="feature-card-top"><span class="feature-icon" aria-hidden="true"><svg viewBox="0 0 20 20"><path d="M3 4h14v12H3zM3 8h14M8 4v12M13 4v12"/></svg></span><h3>Filtrá por especialidad</h3></div>
            <p>Acotá la búsqueda por mecánica, electricidad u otras áreas.</p>
          </article>
          <article class="feature-card">
            <div class="feature-card-top"><span class="feature-icon" aria-hidden="true"><svg viewBox="0 0 20 20"><path d="M10 17s5.5-5.2 5.5-9A5.5 5.5 0 0 0 4.5 8c0 3.8 5.5 9 5.5 9Z"/><circle cx="10" cy="8" r="1.8"/></svg></span><h3>Ubicá cada objeto</h3></div>
            <p>Consultá sector, estante, armario y cajón cuando corresponda.</p>
          </article>
        </div>
      </div>
    </section>
  </div>
</template>
