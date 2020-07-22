import 'package:flutter/material.dart';

class ChimeDefaultVideoRenderView extends StatefulWidget
{
    @override
    _ChimeDefaultVideoRenderViewState createState()
    => _ChimeDefaultVideoRenderViewState();
}

class _ChimeDefaultVideoRenderViewState extends State<ChimeDefaultVideoRenderView>
{
    @override
    Widget build(BuildContext context)
    {
        return AndroidView(
            viewType: 'ChimeDefaultVideoRenderView'
        );
    }
}
