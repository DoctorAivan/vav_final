<!DOCTYPE html>
<html lang="es">
	<head>

		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.4.17.0.min.js"></script>

		<!-- Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Ruta principal de la APP
			const path_app = '<?php echo $_APP; ?>';

		//	Pubnub Monitoreo de Mesas
		    pubnub = new PubNub(
			{
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>"
		    });

		</script>

		<!-- Funcionalidades por Defecto -->
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.totem.css<?php echo $_CONF_VERSION; ?>"/>
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.totem.floating.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

		<div id="render">
			<div id="no-cursor"></div>
			<div id="render-mesa-1" class="tottem transition-on"></div>
			<div id="render-mesa-2" class="tottem transition-on"></div>
			<div id="render-mesa-totales" class="floating transition-on"></div>
		</div>

		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.swich.totem.js<?php echo $_CONF_VERSION; ?>"></script>

	</body>
</html>