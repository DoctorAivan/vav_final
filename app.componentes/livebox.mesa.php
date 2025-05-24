        <!-- Livebox Mesa -->
        <div class="livebox" id="livebox-mesa">
			<div class="livebox-bloqueado"></div>
			<div onclick="liveboxCerrar();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<h2>Crear una Mesa</h2>
				<h3>Selecciona tipo votación y una comuna</h3>
			</header>
			<article class="formulario formulario-pt bg-1">
				<div class="col-1">
					<h2>Selecciona el tipo de votación <span>Obligatorio</span></h2>
				</div>
				<div class="col-1 tipo-mesa bg-1" id="mesa-tipo">
					<div class="box-shadow-light" onclick="mesa_nueva_tipo('P');" id="mesa-tipo-P">🔴&nbsp;&nbsp;&nbsp;PRESIDENCIALES</div>
					<div class="box-shadow-light off" id="mesa-tipo-A">🔵&nbsp;&nbsp;&nbsp;ALCALDES</div>
				</div>
			</article>
			<article class="formulario bg-1">
				<div class="col-1">
					<h2>Define una zona <span>Obligatorio</span></h2>
					<input name="mesa_nueva_comuna" id="mesa_nueva_comuna" type="text" class="alfanumerico input-autocomplate box-shadow-light bordes-radius" autocomplete="off" placeholder="Providencia" />
					<h3><i class="fas fa-info-circle"></i> Deberás hacer un click sobre la zona</h3>
				</div>
			</article>
			<noscript>
			<article class="formulario bg-1">
				<div class="col-1">
					<h2>Selecciona una Región <span>Obligatorio</span></h2>
					<div id="mesa-regiones-listado" class="regiones-listado"></div>
				</div>
			</article>
			</noscript>
			<footer onselectstart="return false">
				<div class="livebox-cargando">
					<i class="fas fa-spinner"></i>
				</div>
				<div class="of" onclick="liveboxCerrar();">
					<h2><i class="fas fa-times-circle"></i> Cancelar</h2>
				</div>
				<div id="mesa-nueva-of" class="of">
					<h2><i class="fas fa-check-circle"></i> Continuar</h2>
				</div>
				<div id="mesa-nueva-on" class="on" onclick="mesa_nueva_confirmar();">
					<h2><i class="fas fa-check-circle"></i> Continuar</h2>
				</div>
			</footer>
		</div>

        <!-- Livebox Mesa Detalles -->
        <div class="livebox" id="livebox-mesa-detalles">
			<div class="livebox-bloqueado"></div>
			<div onclick="liveboxCerrar();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<div class="livebox-id" id="livebox_mesa_id"><span>20</span></div>
				<span style="width: 80px;"><i class="far fa-clipboard"></i></span>
				<h2 class="icono line-1" id="livebox-mesa-titulo">Información de la Mesa</h2>
				<h3 class="icono" id="livebox-mesa-bajada">Configuración y datos de la Mesa</h3>
			</header>
			<article class="formulario bg-1" style="padding: 24px 0 0 var(--padding-box);">
				<div class="col-2">
					<h2>Estado <span>Obligatorio</span></h2>
<?php
				//	Generar Listado de Objetos seleccionables
				//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ] , [ Posición TollTip ]
					generarMesaEstado( 'icono' , 'mesa_estado' , $_USUARIO->usuario_genero , $_ARRAY_ESTADO_MESAS , 'top' );
?>
				</div>
				<div class="col-2">						
					<h2>Dueño <span>Obligatorio</span></h2>
<?php
				//	Generar Listado de Objetos seleccionables
				//	Configuración 	[ Id Objeto ] , [ Actual ] , [ Array ]
					generarSelect( 'usuario_id' , 0 , $_ARRAY_USUARIOS );
?>
				</div>
				<div class="col-2">
					<h2>Comuna <span>Obligatorio</span></h2>
					<input name="mesa_comuna" id="mesa_comuna" type="text" class="uppercase alfanumerico box-shadow-light bordes-radius" autocomplete="off" placeholder="Providencia" />
				</div>
				<div class="col-2">
					<h2>Numero de mesa <span>MESA 25</span></h2>
					<input name="mesa_numero" id="mesa_numero" type="text" class="uppercase alfanumerico box-shadow-light bordes-radius" autocomplete="off" placeholder="M 115" />
				</div>
				<div class="col-1">
					<h2>Nombre del local de votación <span id="mesa_local_largo"><b>25 Caracteres</b> disponibles</span></h2>
					<input name="mesa_local" id="mesa_local" type="text" class="uppercase alfanumerico box-shadow-light bordes-radius" autocomplete="off" placeholder="Estadio Nacional" maxlength="25" />
				</div>
			</article>
			<article class="formulario candidatos bg-1">

				<div class="col-1" style="display:none; border-top:solid 1px #454757; padding:10px 0 0 var(--padding-box);">
					<div class="tags-input">
						<i class="icono-fixed fas fa-search"></i>
						<input style="margin:14px 0 18px 0;" name="candidato_nombre" id="candidato_nombre" type="text" class="alfanumerico input-filtro-candidatos box-shadow-light bordes-radius" autocomplete="off" placeholder="FILTRAR POR NOMBRE" style="margin:14px 0 23px 0;">
					</div>
					<div class="filtro-boton box-shadow-light" onclick="limpiarFiltro();">
						<span>VER TODOS</span>
					</div>
				</div>

				<div class="candidato-titulos titulo">
					<div class="candidato-titulo">Nombre candidato en pantalla <i class="fas fa-chevron-down"></i></div>
					<div class="candidato-titulo" style="text-align: right;">
						Modificar Votos <i class="fas fa-chevron-down"></i>
					</div>
				</div>
				<div class="candidatos-listado">
				<noscript>
					<div class="candidatos-listado-titulo"><i class="fas fa-circle candidatos-lista-b"></i> UNIDAD CONSTITUYENTE <i class="fas fa-chevron-down"></i></div>
				</noscript>
					<div class="candidatos-listado-lista" id="candidatos-lista"></div>
				</div>
			</article>
			<footer onselectstart="return false">
				<div class="livebox-cargando">
					<i class="fas fa-spinner"></i>
				</div>
				<div class="of" onclick="liveboxCerrar();">
					<h2><i class="fas fa-times-circle"></i> Cerrar</h2>
				</div>
				<div class="on" onclick="mesa_detalles_confirmar();">
					<h2><i class="fas fa-check-circle"></i> Guardar</h2>
				</div>
			</footer>
		</div>

        <!-- Livebox Mesa Eliminar -->
        <div class="livebox" id="livebox-mesa-eliminar">
			<div class="livebox-bloqueado"></div>
			<div onclick="liveboxCerrar();" class="livebox-cerrar"><i class="fas fa-times"></i></div>
			<header>
				<h2>Eliminar una Mesa</h2>
				<h3>Será eliminada toda la información relacionada</h3>
			</header>
			<footer onselectstart="return false">
				<div class="livebox-cargando">
					<i class="fas fa-spinner"></i>
				</div>
				<div class="of" onclick="liveboxCerrar();">
					<h2><i class="fas fa-times-circle"></i> Cancelar</h2>
				</div>
				<div class="on" onclick="mesa_eliminar_confirmar();">
					<h2><i class="fas fa-check-circle"></i> Eliminar</h2>
				</div>
			</footer>
		</div>