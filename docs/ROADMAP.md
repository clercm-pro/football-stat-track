# Roadmap

This document outlines the development timeline, milestones, and next steps for StatTrack.

---

## Project Phases

| Phase | Duration | Deliverables | Priority | Status |
|-------|----------|--------------|----------|--------|
| **1. Prototyping** | 2 weeks | Wireframes + Flutter POC | High | Complete |
| **2. Local Backend** | 3 weeks | Models + Hive + CRUD operations | High | Complete |
| **3. Frontend** | 4 weeks | All screens + navigation | High | Complete |
| **4. Synchronization** | 3 weeks | WebRTC + QR Code + conflict resolution | High | In Progress |
| **5. Testing** | 2 weeks | Unit tests + UI tests | Medium | Pending |
| **6. Beta Test** | 2 weeks | 10 users + feedback collection | Medium | Pending |
| **7. Production Release** | 1 week | App Store + Play Store publication | Low | Pending |

---

## Milestones

### Short Term (1-2 weeks)

- [ ] Finalize Flutter prototype
- [ ] Test on Android emulators
- [ ] Test on iOS simulators
- [ ] Fix identified bugs

### Medium Term (1 month)

- [ ] Implement peer-to-peer synchronization
- [ ] Add data encryption
- [ ] Test sync between 2 physical devices
- [ ] Write unit tests for core functionality

### Long Term (2-3 months)

- [ ] Publish on Google Play Store
- [ ] Publish on Apple App Store
- [ ] Add advanced features:
  - Export/import functionality
  - Optional cloud backup
  - Multi-sport support
  - Team statistics
- [ ] Localization (French, English, Spanish)

---

## Current Status Summary

### Completed

✅ **Prototyping Phase**
- All wireframes designed
- Flutter POC validated
- Technical stack confirmed

✅ **Local Backend Phase**
- Hive database integration
- CRUD operations for all entities
- Data persistence working

✅ **Frontend Phase**
- Home screen implemented
- Profile screen implemented
- Match screen implemented
- Create profile/season screens implemented
- Navigation working

### In Progress

🔄 **Synchronization Phase**
- WebRTC integration: 60% complete
- QR code scanning: 30% complete
- Conflict resolution: Not started
- Encryption: Not started

### Pending

⏳ **Testing Phase**
- Unit tests for models
- Unit tests for providers
- UI tests for screens
- Integration tests

⏳ **Beta Test Phase**
- Recruit beta testers
- Collect feedback
- Fix critical issues
- Performance optimization

⏳ **Production Release Phase**
- App Store submission
- Play Store submission
- Marketing materials
- Press release

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-08-23 | Initial release with complete specifications |

---

## Glossary

| Term | Definition |
|------|------------|
| **Profile** | Entity representing a player (child or adult) |
| **Season** | Period of 2 years (e.g., 2026/2027) |
| **Match** | Game session with timer, goals, and assists |
| **Peer-to-Peer Sync** | Direct synchronization between devices without a server |
| **Hive** | Local NoSQL database for Flutter |
| **Riverpod** | State management library for Flutter |

---

## References

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [WebRTC Flutter Package](https://pub.dev/packages/flutter_webrtc)
- [Color Palette](https://colorhunt.co/palette/362f4f5b23ff008bffe4ff30)

---

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**See also:**
- [Functional Specifications](FUNCTIONAL-SPECS.md) for feature details
- [Technical Architecture](ARCHITECTURE.md) for system design
- [Setup Guide](SETUP.md) for development instructions
