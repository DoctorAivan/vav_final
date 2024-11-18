        <!-- Livebox Mesa -->
        <div class="livebox" id="livebox-consolidados">
			<div class="livebox-bloqueado"></div>
			<div onclick="liveboxCerrar();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<h2>Consolidados</h2>
				<h3>Selecciona el tipo de votación y una comuna</h3>
			</header>
			<article class="formulario formulario-pt bg-1">
				<div class="col-1">
					<h2>Selecciona el tipo de votación <span>Obligatorio</span></h2>
				</div>
				<div class="col-1 tipo-mesa bg-1" id="consolidado-tipo">
					<div class="box-shadow-light" onclick="consolidados_tipo('G');" id="consolidado-tipo-G">🟡&nbsp;&nbsp;&nbsp;GOBERNADORES</div>
					<div class="box-shadow-light off" id="consolidado-tipo-A">🔴&nbsp;&nbsp;&nbsp;ALCALDES</div>
				</div>
			</article>
			<article class="formulario bg-1">
				<div class="col-1">
					<h2>Define una zona <span>Obligatorio</span></h2>
					<input name="mesa_consolidado_comunas" id="mesa_consolidado_comunas" type="text" class="alfanumerico input-autocomplate box-shadow-light bordes-radius" autocomplete="off" placeholder="Providencia" />
					<h3><i class="fas fa-info-circle"></i> Deberás dar un click sobre la zona</h3>
				</div>
			</article>
			<footer onselectstart="return false">
				<div class="livebox-cargando">
					<i class="fas fa-spinner"></i>
				</div>
				<div class="of" onclick="liveboxCerrar();">
					<h2><i class="fas fa-times-circle"></i> Cancelar</h2>
				</div>
				<div id="mesa-nueva-of" class="of">
					<h2><i class="fas fa-check-circle"></i> Confirmar</h2>
				</div>
				<div id="mesa-nueva-on" class="on" onclick="consolidados_guardar();">
					<h2><i class="fas fa-check-circle"></i> Confirmar</h2>
				</div>
			</footer>
		</div>