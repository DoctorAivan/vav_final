<!DOCTYPE html>
<html lang="es">
	<head>

		<!-- Librerias PubNub -->
        <script src="https://cdn.pubnub.com/sdk/javascript/pubnub.8.2.8.js"></script>

		<!-- Funcionalidades por Defecto -->
		<script type="text/javascript">

		//	Ruta principal de la APP
			const path_app = '<?php echo $_APP; ?>';

		//	Pubnub Monitoreo de Mesas
			pubnub = new PubNub({
				subscribeKey	:	"<?php echo $_PUBNUB_SUS_MESAS; ?>",
				publishKey		:	"<?php echo $_PUBNUB_PUB_MESAS; ?>",
				secretKey		:	"<?php echo $_PUBNUB_SECRET_KEY; ?>",
				userId			:	"<?php echo $_PUBNUB_USER_ID; ?>"
            });

		</script>

		<!-- Funcionalidades por Defecto -->
		<link rel="stylesheet" type="text/css" href="<?php echo $_LIBRERIAS_CSS; ?>vav.swich.quad.tv.css<?php echo $_CONF_VERSION; ?>"/>

	</head>
	<body>

		<div id="render">
			<div id="no-cursor"></div>
			<div class="mesas">
				<div class="mesa anim_view_out" id="view-1">1</div>
				<div class="mesa anim_view_out" id="view-2">2</div>
				<div class="mesa anim_view_out" id="view-3">3</div>
				<div class="mesa anim_view_out" id="view-4">4</div>
			</div>
		</div>

		<script type="text/javascript" src="<?php echo $_LIBRERIAS_JS; ?>pubNub.swich.quad.tv.js<?php echo $_CONF_VERSION; ?>"></script>

	</body>
</html>