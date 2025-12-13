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
					<div class="box-shadow-light" onclick="consolidados_tipo('P');" id="consolidado-tipo-P">🔴&nbsp;&nbsp;&nbsp;Presidentes</div>
					<div class="box-shadow-light" onclick="consolidados_tipo('S');" id="consolidado-tipo-S">🔵&nbsp;&nbsp;&nbsp;Senadores</div>
					<div class="box-shadow-light" onclick="consolidados_tipo('D');" id="consolidado-tipo-D">🟠&nbsp;&nbsp;&nbsp;Diputados</div>
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

        <!-- Livebox Mesa -->
        <div class="livebox" id="livebox-consolidados-titulo">
			<div class="livebox-bloqueado"></div>
			<div onclick="liveboxCerrar();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<h2>Configuración consolidados</h2>
				<h3>Edición del título en pantalla en tiempo real</h3>
			</header>
			<article class="formulario bg-1">
				<div class="col-1">
					<h2>Título en pantalla actual <span>Obligatorio</span></h2>
					<input name="input_consolidado_titulo" id="input_consolidado_titulo" type="text" class="alfanumerico box-shadow-light bordes-radius" autocomplete="off" placeholder="Consolidados CHV" />
					<h3 id="input_consolidado_titulo_mensaje"><	/h3>
				</div>
			</article>
			<footer onselectstart="return false">
				<div class="livebox-cargando">
					<i class="fas fa-spinner"></i>
				</div>
				<div class="of" onclick="liveboxCerrar();">
					<h2><i class="fas fa-times-circle"></i> Cerrar</h2>
				</div>
				<div class="on" onclick="consolidados_asignar_titulo_confirmar();">
					<h2><i class="fas fa-check-circle"></i> Confirmar</h2>
				</div>
			</footer>
		</div>