import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

// Prefix for hashtag links (for location | item | map | chapter | adventure | scene | encounter)
const String prefixHashtag = "-moonforge-hashtag-entity-";

// Prefix for mention links (for creature | organisation)
const String prefixMention = "-moonforge-mention-entity-";

final defaultMentionStyles = DefaultStyles(
  link: const TextStyle().copyWith(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  ),
);
