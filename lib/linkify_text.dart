library linkify_text_package;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

class _Word {
  final String text;
  final bool isLink;

  _Word({required this.text, this.isLink = false});
}

class _Linkify {
  static List<_Word> parseLink(String text) {
    List<_Word> words = [];

    RegExp exp = RegExp(
        r"((https?|ftp|smtp):\/\/)?(www.)?[a-z0-9]+(\.[a-z]+)+(\/[a-zA-Z0-9#]+\/?)*");

    Iterable<RegExpMatch> list = exp.allMatches(text);

    int prevEnd = 0;
    int currentStart = 0;
    int currentEnd = 0;

    list.toList().forEach((RegExpMatch e) {
      currentStart = e.start;
      currentEnd = e.end;

      if (currentStart != prevEnd) {
        final String normalString = text.substring(prevEnd, currentStart);
        _Word word = _Word(text: normalString);
        words.add(word);
      }

      final String linkString = text.substring(currentStart, currentEnd);
      _Word word = _Word(text: linkString, isLink: true);
      words.add(word);

      prevEnd = currentEnd;
    });

    if (currentEnd != text.length) {
      final String normalString = text.substring(currentEnd, text.length);
      _Word word = _Word(text: normalString);
      words.add(word);
    }

    return words;
  }
}

class LinkifyText extends StatefulWidget {
  final String data;
  final Color? fontColor;
  final double? fontSize;
  final Color? linkColor;
  final String? fontFamily;
  final bool isLinkNavigationEnable;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  LinkifyText(
    this.data, {
    this.fontColor,
    this.linkColor,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.isLinkNavigationEnable = true,
  });

  @override
  _LinkifyTextState createState() => _LinkifyTextState();
}

class _LinkifyTextState extends State<LinkifyText> {
  late List<_Word> words;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _launchURL(String url) async {
    if (!url.startsWith(r"https?://")) url = "https://" + url;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    words = _Linkify.parseLink(widget.data);
    return Text.rich(
      TextSpan(
        children: words.map((_Word word) {
          return word.isLink
              ? TextSpan(
                  text: word.text,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontFamily: widget.fontFamily,
                    fontWeight: widget.fontWeight ?? FontWeight.normal,
                    color: widget.linkColor ?? Colors.blue[700],
                    fontStyle: widget.fontStyle ?? FontStyle.normal,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      if (!widget.isLinkNavigationEnable) return;
                      _launchURL(word.text);
                    },
                )
              : TextSpan(
                  text: word.text,
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 15.0,
                    fontFamily: widget.fontFamily,
                    fontStyle: widget.fontStyle ?? FontStyle.normal,
                    fontWeight: widget.fontWeight ?? FontWeight.normal,
                    color: widget.fontColor ?? Colors.white,
                  ),
                );
        }).toList(),
      ),
    );
  }
}
