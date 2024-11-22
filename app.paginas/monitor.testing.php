<!DOCTYPE html>
<html lang="es">
	<head>

<?php

	//	Etiquetas Metags
		include_once "$_COMPONENTES/head.metatags.php";

	//	Librerias JS y CSS globales
		include_once "$_COMPONENTES/librerias.js.css.php";

?>

<!--	Libreria Funcionalidad Mesas	-->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.mesas.js<?php echo $_CONF_VERSION; ?>"></script>

<!--	Librerias -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>cis.listado.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.listado.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>cis.formulario.css<?php echo $_CONF_VERSION; ?>"/>

<!--	Librerias PubNub -->
		<script src="https://cdn.pubnub.com/sdk/javascript/pubnub.8.2.8.js"></script>
        
<!--	Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Pubnub Monitoreo de Mesas
			pubnub = new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>",
				secretKey		:	"<?php echo $_PUBNUB_SECRET_KEY; ?>",
				userId			:	"<?php echo $_PUBNUB_USER_ID; ?>"
            });

		</script>
		
<!--	Funcionalidad PubNub -->
		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>vav.monitor.testing.js<?php echo $_CONF_VERSION; ?>"></script>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.monitor.testing.css<?php echo $_CONF_VERSION; ?>"/>

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
						<div class="icono"><i class="fas fa-vial"></i></div>
						<h2 class="icono-on">Simulador de Votos</h2>
						<h3 class="icono-on">Listado de mesas en pantalla</h3>
						<div class="test-votos">
							<div class="accion" onclick="enviar_voto_init();">
								<i id="test-votos-boton" class="fas fa-play-circle"></i>
							</div>
							<div>
								<div id="test-votos-estado" class="mesas">Detenido</div>
								<div class="detalles">Envio de votos</div>
							</div>
						</div>
					</header>
				</section>
			</section>

			<section class="main-cnt cols x5" id="mesas">
				
			</section>

		</section>

<?php

	//	Footer
		include_once "$_COMPONENTES/footer.php";

?>

	</body>
</html>