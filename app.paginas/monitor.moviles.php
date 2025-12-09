<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.8.2.8.js"></script>
        
		<!-- Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
			pubnub				=	new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>",
				secretKey		:	"<?php echo $_PUBNUB_SECRET_KEY; ?>",
				userId			:	"mobile_monitor"
		    });
			
		//	Pubnub Monitoreo de Mesas
			pubnubMovil			=	new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>",
				secretKey		:	"<?php echo $_PUBNUB_SECRET_KEY; ?>",
				userId			:	"mobile_monitor"
		    });

		</script>

		<!-- Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.movil.acciones.js<?php echo $_CONF_VERSION; ?>"></script>

		<!-- Libreria Iconos Fontawesome -->
		<link rel="stylesheet" href="<?php echo $_LIBRERIAS_CSS; ?>monitor.movil.css<?php echo $_CONF_VERSION; ?>">

	</head>
	<body>

<?php

	//	Navegacion
		include_once "$_COMPONENTES/navegacion.principal.php";

	//	Header
		include_once "$_COMPONENTES/header.php";

?>

		<section class="main">
			
			<section class="main-cnt cols x1 margin-bottom">
				<section class="bg-blanco box-shadow bordes-radius crop">
					<header class="titulo-seccion no-border">
						<div class="icono"><i class="fas fa-mobile-alt"></i></div>
						<h2 class="icono-on">Monitor Moviles</h2>
						<h3 class="icono-on">Listado de interacciones con los dispositivos moviles</h3>
						<div class="opciones">
							<div class="boton nuevo box-shadow-light bordes-radius" onclick="borrarHistorial();"><i class="fas fa-ban"></i> Borrar Historial</div>
						</div>
					</header>
				</section>
			</section>

			<section class="main-cnt cols x1">
				<div class="bg-blanco box-shadow bordes-radius">
					<div class="debug">
						<div class="box monitor-header">
							<div class="hora">Usuarios <i class="fas fa-chevron-down"></i></div>
							<div class="bold verde">Acción <i class="fas fa-chevron-down"></i></div>
							<div class="comuna">Comuna <i class="fas fa-chevron-down"></i></div>
							<div class="">Local <i class="fas fa-chevron-down"></i></div>
							<div class="">Numero <i class="fas fa-chevron-down"></i></div>
							<div class="hora">Publicación <i class="fas fa-chevron-down"></i></div>
						</div>
					</div>
					<div class="debug" id="debug">
						<div class="box debug_vavio">
							Aun no existen notificaciones
						</div>
					</div>
				</div>
			</section>

		</section>

<?php

	//	Footer
		include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>