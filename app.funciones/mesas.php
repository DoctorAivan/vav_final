<?php

//  Obtener el icono relacionado
    function obtener_icono( $icono )
    {
        if( $icono == 'G' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'A' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'P' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'S' )
        {
            return 'fa-sticky-note';
        }
        else if( $icono == 'D' )
        {
            return 'fa-sticky-note';
        }
    }

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//  Obtener el titulo del tipo
    function obtener_titulo( $icono )
    {
        if( $icono == 'G' )
        {
            return '🔴&nbsp;&nbsp;&nbsp;GOBERNADORES';
        }
        else if( $icono == 'A' )
        {
            return '🔵&nbsp;&nbsp;&nbsp;ALCALDES';
        }
        else if( $icono == 'P' )
        {
            return '🔴&nbsp;&nbsp;&nbsp;PRESIDENCIALES';
        }
        else if( $icono == 'S' )
        {
            return '🔵&nbsp;&nbsp;&nbsp;SENADORES';
        }
        else if( $icono == 'D' )
        {
            return '🟠&nbsp;&nbsp;&nbsp;DIPUTADOS';
        }
    }

?>