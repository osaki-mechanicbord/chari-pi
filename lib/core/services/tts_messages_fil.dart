import '../../data/models/osm_node.dart';

/// フィリピン語 TTS メッセージ
String getTtsMessageFil(OSMNode node, int stage, int dist, {double? userSpeed}) {
  switch (node.type) {
    case OSMNodeType.stopSign:
      switch (stage) {
        case 1: return 'May stop sign sa unahan';
        case 2: return 'Papalapit sa stop sign. Bagalan mo';
        case 3: return 'Stop sign. Humintong ganap';
        default: return '';
      }
    case OSMNodeType.trafficSignal:
      switch (stage) {
        case 1: return 'May traffic signal sa unahan, $dist metro';
        case 2: return 'Papalapit sa traffic signal. Tingnan ang ilaw';
        case 3: return 'Traffic signal. Sundin ang ilaw';
        default: return '';
      }
    case OSMNodeType.oneway:
      if (node.isWrongWay) {
        switch (stage) {
          case 1: return 'Babala. One-way street sa unahan. Suriin ang direksyon';
          case 2: return 'Panganib. Kontra daloy ka sa one-way. Huminto sa ligtas na lugar';
          case 3: return 'Kontra daloy. Huminto kaagad';
          default: return '';
        }
      }
      switch (stage) {
        case 1: return 'May one-way street sa unahan, $dist metro';
        case 2: return 'Papalapit sa one-way street. Suriin ang direksyon';
        case 3: return 'One-way street. Mag-ingat sa direksyon';
        default: return '';
      }
    case OSMNodeType.pedestrianRoad:
      switch (stage) {
        case 1: return 'Pedestrian zone sa unahan. Bawal ang bisikleta';
        case 2: return 'Papalapit sa pedestrian zone. Umikot';
        case 3: return 'Pedestrian zone. Bawal ang bisikleta';
        default: return '';
      }
    case OSMNodeType.footway:
      switch (stage) {
        case 2: return 'Sidewalk ito. Tingnan kung may karatula na pinapayagan ang bisikleta';
        case 3: return 'Maaaring nasa sidewalk ka. Suriin ang karatula. Kung bawal, bumaba at maglakad';
        default: return '';
      }
    case OSMNodeType.footwayNoBicycle:
      switch (stage) {
        case 1: return 'Bawal ang bisikleta sa sidewalk sa unahan';
        case 2: return 'Papalapit sa sidewalk na bawal ang bisikleta';
        case 3: return 'Bawal ang bisikleta sa sidewalk na ito. Bumaba at maglakad';
        default: return '';
      }
    case OSMNodeType.cycleway:
      switch (stage) {
        case 1: return 'May cycle lane malapit';
        case 2: return 'Cycle lane. Gamitin ang daang ito';
        default: return '';
      }
    case OSMNodeType.crossing:
      switch (stage) {
        case 1: return 'May crosswalk sa unahan, $dist metro';
        case 2: return 'Papalapit sa crosswalk. Mag-ingat sa mga pedestrian';
        case 3: return 'Crosswalk. Huminto kung may pedestrian';
        default: return '';
      }
    case OSMNodeType.noBicycle:
      switch (stage) {
        case 1: return 'Bawal ang bisikleta sa unahan. Umikot';
        case 2: return 'Papalapit sa no-cycling zone';
        case 3: return 'Bawal ang bisikleta dito. Umikot kaagad';
        default: return '';
      }
    case OSMNodeType.dismount:
      switch (stage) {
        case 1: return 'Dismount zone sa unahan';
        case 2: return 'Papalapit sa dismount zone. Bumaba sa bisikleta';
        case 3: return 'Dismount zone. Bumaba at maglakad';
        default: return '';
      }
    case OSMNodeType.speedLimit:
      if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
        return 'Speed limit dito ${node.speedLimit} km/h. Kasalukuyang bilis ${userSpeed.round()} km/h. Bagalan mo';
      }
      if (stage >= 2 && node.speedLimit != null) {
        return 'Speed limit dito ${node.speedLimit} km/h';
      }
      return '';
    case OSMNodeType.accidentZone:
      switch (stage) {
        case 1: return 'Accident-prone area sa unahan. Mag-ingat';
        case 2: return 'Accident-prone area. Maging maingat';
        default: return '';
      }
    case OSMNodeType.enforcementZone:
      switch (stage) {
        case 1: return 'Traffic enforcement zone sa unahan. Sundin ang batas trapiko';
        case 2: return 'Enforcement zone. Mag-ingat sa paglabag';
        default: return '';
      }
  }
}
