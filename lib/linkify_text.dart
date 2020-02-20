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

  _Word({this.text, this.isLink = false});
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
  final String text;
  final Color textColor;
  final double textSize;
  final Color linkColor;
  final String fontFamily;
  final bool isLinkNavigationEnable;
  final FontWeight fontWeight;

  LinkifyText(
    this.text, {
    this.textColor,
    this.linkColor,
    this.textSize,
    this.fontFamily,
    this.fontWeight,
    this.isLinkNavigationEnable = true,
  });

  @override
  _LinkifyTextState createState() => _LinkifyTextState();
}

class _LinkifyTextState extends State<LinkifyText> {
  List<_Word> words;

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
    words = _Linkify.parseLink(widget.text);
    return Text.rich(TextSpan(
        children: words.map((_Word word) {
      return word.isLink
          ? TextSpan(
              text: word.text,
              style: TextStyle(
                  fontSize: widget.textSize,
                  fontFamily: widget.fontFamily,
                  fontWeight: widget.fontWeight ?? FontWeight.normal,
                  color: widget.linkColor ?? Colors.blue[700],
                  decoration: TextDecoration.underline),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  if (!widget.isLinkNavigationEnable) return;
                  _launchURL(word.text);
                },
            )
          : TextSpan(
              text: word.text,
              style: TextStyle(
                  fontSize: widget.textSize ?? 15.0,
                  fontFamily: widget.fontFamily,
                  fontWeight: widget.fontWeight ?? FontWeight.normal,
                  color: widget.textColor ?? Colors.white),
            );
    }).toList()));
  }
}