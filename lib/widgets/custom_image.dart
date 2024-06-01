import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

cachedNetworkImage(String mediaUrl,
    {width = 200.0,
    height = 150.0,
    radius = 0.0,
    topOnly = false,
    boxFit = BoxFit.cover}) {
  return ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomRight: topOnly ? const Radius.circular(0) : Radius.circular(radius),
      bottomLeft: topOnly ? const Radius.circular(0) : Radius.circular(radius),
    ),
    child: SizedBox(
      width: width,
      height: height,
      child: CachedNetworkImage(
        fit: boxFit,
        imageUrl: "https://zefaafapi.com/uploadFolder/small/$mediaUrl",
        width: width,
        height: height,
        placeholder: (context, url) {
          return Center(
            child: circularProgress(context),
          );
        },
        errorWidget: (context, url, error) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/logo.png"),
          );
        },
      ),
    ),
  );
}

circularProgress(context) {}
