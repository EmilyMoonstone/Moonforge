import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'campaign.g.dart';

@Riverpod(keepAlive: true)
class CurrentCampaignId extends _$CurrentCampaignId {
  @override
  String? build() {
    return null;
  }

  void set(String? campaignId) {
    state = campaignId;
  }
}
