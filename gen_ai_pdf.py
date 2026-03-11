"""
MCH Kenya — AI Features Report PDF Generator
Generates a professional PDF document summarizing all AI features implemented.
"""

from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, KeepTogether
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_JUSTIFY
from datetime import datetime
import os

OUTPUT_PATH = os.path.join(os.path.dirname(__file__), "MCH_Kenya_AI_Features_Report.pdf")

# ── Color Palette ─────────────────────────────────────────────────────────────
PRIMARY    = colors.HexColor("#1565C0")   # Deep Blue
SECONDARY  = colors.HexColor("#7B1FA2")   # Purple
SUCCESS    = colors.HexColor("#2E7D32")   # Green
WARNING    = colors.HexColor("#E65100")   # Orange
ACCENT     = colors.HexColor("#00838F")   # Teal
LIGHT_BG   = colors.HexColor("#F3F4F6")
DARK_TEXT  = colors.HexColor("#1A1A2E")
MUTED      = colors.HexColor("#6B7280")
WHITE      = colors.white

# ── Styles ────────────────────────────────────────────────────────────────────
styles = getSampleStyleSheet()

title_style = ParagraphStyle(
    "Title", parent=styles["Title"],
    fontSize=26, leading=32, textColor=WHITE,
    fontName="Helvetica-Bold", alignment=TA_CENTER,
)
subtitle_style = ParagraphStyle(
    "Subtitle", parent=styles["Normal"],
    fontSize=12, leading=16, textColor=colors.HexColor("#BBDEFB"),
    fontName="Helvetica", alignment=TA_CENTER,
)
h1_style = ParagraphStyle(
    "H1", parent=styles["Heading1"],
    fontSize=16, leading=22, textColor=PRIMARY,
    fontName="Helvetica-Bold", spaceBefore=14, spaceAfter=6,
)
h2_style = ParagraphStyle(
    "H2", parent=styles["Heading2"],
    fontSize=13, leading=18, textColor=DARK_TEXT,
    fontName="Helvetica-Bold", spaceBefore=10, spaceAfter=4,
)
body_style = ParagraphStyle(
    "Body", parent=styles["Normal"],
    fontSize=10, leading=15, textColor=DARK_TEXT,
    fontName="Helvetica", spaceAfter=4, alignment=TA_JUSTIFY,
)
bullet_style = ParagraphStyle(
    "Bullet", parent=styles["Normal"],
    fontSize=10, leading=14, textColor=DARK_TEXT,
    fontName="Helvetica", leftIndent=14, spaceAfter=3,
    bulletIndent=4, bulletFontName="Helvetica",
)
code_style = ParagraphStyle(
    "Code", parent=styles["Normal"],
    fontSize=8.5, leading=12, textColor=colors.HexColor("#1B5E20"),
    fontName="Courier", leftIndent=12, spaceAfter=2, backColor=LIGHT_BG,
)
small_style = ParagraphStyle(
    "Small", parent=styles["Normal"],
    fontSize=8, leading=11, textColor=MUTED, fontName="Helvetica",
)
badge_style = ParagraphStyle(
    "Badge", parent=styles["Normal"],
    fontSize=9, leading=12, textColor=WHITE,
    fontName="Helvetica-Bold", alignment=TA_CENTER,
)


def bullet(text, color=PRIMARY):
    """Return a bullet paragraph."""
    return Paragraph(f"<bullet> •</bullet> {text}", bullet_style)


def hr(color=PRIMARY):
    return HRFlowable(width="100%", thickness=1.5, color=color, spaceAfter=6)


def phase_table(title, color, items):
    """Build a colored phase card as a table."""
    data = [[Paragraph(f"<b>{title}</b>", ParagraphStyle(
        "PhTitle", parent=styles["Normal"],
        fontSize=11, leading=14, textColor=WHITE, fontName="Helvetica-Bold"
    ))]]
    for item in items:
        data.append([Paragraph(f"✓  {item}", ParagraphStyle(
            "PhItem", parent=styles["Normal"],
            fontSize=9.5, leading=13, textColor=WHITE, fontName="Helvetica",
        ))])
    t = Table(data, colWidths=[17 * cm])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (0, 0), color),
        ("BACKGROUND", (0, 1), (-1, -1), colors.HexColor(
            f"#{hex(max(0, int(color.hexval()[1:], 16) - 0x101010))[2:].zfill(6)}"
        ) if False else color.clone(alpha=0.85)),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [
            colors.HexColor("#FFFFFF"), colors.HexColor("#F8F9FF")
        ]),
        ("TEXTCOLOR", (0, 0), (-1, -1), WHITE),
        ("FONTNAME",  (0, 0), (-1, -1), "Helvetica"),
        ("FONTSIZE",  (0, 0), (-1, -1), 10),
        ("TOPPADDING",    (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
        ("LEFTPADDING",   (0, 0), (-1, -1), 12),
        ("RIGHTPADDING",  (0, 0), (-1, -1), 12),
        ("BOX",  (0, 0), (-1, -1), 0.5, colors.HexColor("#CCCCDD")),
        ("ROWBACKGROUNDS", (0, 0), (0, 0), [color]),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [
            colors.HexColor("#EEF2FF"), colors.HexColor("#F8FAFF")
        ]),
        ("TEXTCOLOR", (0, 1), (-1, -1), DARK_TEXT),
        ("FONTNAME",  (0, 1), (-1, -1), "Helvetica"),
    ]))
    return t


def file_table(rows):
    """Build a file listing table."""
    header = [
        Paragraph("<b>File</b>", ParagraphStyle("TH", parent=styles["Normal"],
            fontSize=9, fontName="Helvetica-Bold", textColor=WHITE)),
        Paragraph("<b>Status</b>", ParagraphStyle("TH", parent=styles["Normal"],
            fontSize=9, fontName="Helvetica-Bold", textColor=WHITE)),
        Paragraph("<b>Description</b>", ParagraphStyle("TH", parent=styles["Normal"],
            fontSize=9, fontName="Helvetica-Bold", textColor=WHITE)),
    ]
    data = [header]
    for fname, status, desc in rows:
        sc = SUCCESS if status == "NEW" else PRIMARY if status == "MODIFIED" else MUTED
        data.append([
            Paragraph(f"<code>{fname}</code>", ParagraphStyle("FC", parent=styles["Normal"],
                fontSize=8, fontName="Courier", textColor=DARK_TEXT)),
            Paragraph(f"<b>{status}</b>", ParagraphStyle("FS", parent=styles["Normal"],
                fontSize=8, fontName="Helvetica-Bold", textColor=sc)),
            Paragraph(desc, ParagraphStyle("FD", parent=styles["Normal"],
                fontSize=8, fontName="Helvetica", textColor=DARK_TEXT)),
        ])
    t = Table(data, colWidths=[6.5*cm, 2*cm, 8.5*cm])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), PRIMARY),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [WHITE, LIGHT_BG]),
        ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#CCCCDD")),
        ("TOPPADDING",    (0, 0), (-1, -1), 6),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
        ("LEFTPADDING",   (0, 0), (-1, -1), 8),
        ("RIGHTPADDING",  (0, 0), (-1, -1), 8),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
    ]))
    return t


def build_pdf():
    doc = SimpleDocTemplate(
        OUTPUT_PATH, pagesize=A4,
        leftMargin=2*cm, rightMargin=2*cm,
        topMargin=1.5*cm, bottomMargin=2*cm,
        title="MCH Kenya — AI Features Report",
        author="Antigravity AI",
        subject="Gemini AI Integration Report",
    )

    story = []

    # ── Cover / Hero ─────────────────────────────────────────────────────────
    cover_data = [[
        Paragraph("MCH Kenya", title_style),
        Paragraph("AI Features Implementation Report", subtitle_style),
        Paragraph(
            f"Gemini 1.5 Flash Integration  •  March 2026  •  6 Phases",
            subtitle_style
        ),
    ]]
    cover = Table(cover_data, colWidths=[17*cm])
    cover.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), PRIMARY),
        ("TOPPADDING",    (0, 0), (-1, -1), 20),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 20),
        ("LEFTPADDING",   (0, 0), (-1, -1), 20),
        ("RIGHTPADDING",  (0, 0), (-1, -1), 20),
        ("ROUNDEDCORNERS", [12]),
    ]))
    story.append(cover)
    story.append(Spacer(1, 0.5*cm))

    # ── Summary Stats ─────────────────────────────────────────────────────────
    stats = Table(
        [[
            Paragraph("6\nPhases", ParagraphStyle("Stat", parent=styles["Normal"],
                fontSize=22, leading=26, fontName="Helvetica-Bold",
                textColor=PRIMARY, alignment=TA_CENTER)),
            Paragraph("14\nNew Files", ParagraphStyle("Stat", parent=styles["Normal"],
                fontSize=22, leading=26, fontName="Helvetica-Bold",
                textColor=SECONDARY, alignment=TA_CENTER)),
            Paragraph("2\nApps", ParagraphStyle("Stat", parent=styles["Normal"],
                fontSize=22, leading=26, fontName="Helvetica-Bold",
                textColor=SUCCESS, alignment=TA_CENTER)),
            Paragraph("0\nErrors", ParagraphStyle("Stat", parent=styles["Normal"],
                fontSize=22, leading=26, fontName="Helvetica-Bold",
                textColor=ACCENT, alignment=TA_CENTER)),
        ]],
        colWidths=[4.25*cm]*4
    )
    stats.setStyle(TableStyle([
        ("ROWBACKGROUNDS", (0, 0), (-1, -1), [LIGHT_BG]),
        ("BOX", (0, 0), (-1, -1), 0.5, colors.HexColor("#CCCCDD")),
        ("INNERGRID", (0, 0), (-1, -1), 0.5, colors.HexColor("#DDDDEE")),
        ("TOPPADDING",    (0, 0), (-1, -1), 14),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 14),
    ]))
    story.append(stats)
    story.append(Spacer(1, 0.4*cm))

    # ── Overview ──────────────────────────────────────────────────────────────
    story.append(Paragraph("Overview", h1_style))
    story.append(hr())
    story.append(Paragraph(
        "This report documents the complete integration of Google's <b>Gemini 1.5 Flash</b> AI model "
        "into the MCH Kenya maternal and child health platform. The implementation spans two Flutter "
        "applications — the <b>Patient App</b> (mch_patient) and the <b>Health Worker App</b> "
        "(mch_health_worker) — with shared infrastructure in the <b>mch_core</b> package.",
        body_style
    ))
    story.append(Paragraph(
        "AI features are designed to degrade gracefully when offline, using cached results or "
        "an unavailable banner. All AI calls use the <b>Gemini 1.5 Flash</b> model for optimal "
        "speed and cost-efficiency. API keys are loaded from <code>.env</code> files and never "
        "committed to version control.",
        body_style
    ))
    story.append(Spacer(1, 0.3*cm))

    # ── Phase 1 ───────────────────────────────────────────────────────────────
    story.append(Paragraph("Phase 1 — AI Service Foundation (mch_core)", h1_style))
    story.append(hr(ACCENT))
    story.append(Paragraph(
        "Shared AI infrastructure packaged in <code>mch_core</code> so both apps can use it "
        "without duplicating code.", body_style
    ))
    story.append(Spacer(1, 0.2*cm))
    ph1 = phase_table(
        "Phase 1: Core AI Services — mch_core", ACCENT,
        [
            "GeminiService — wraps the google_generative_ai SDK, handles streaming & text generation",
            "PatientContextBuilder — converts patient records into structured AI prompt context",
            "Both main.dart files initialize GeminiService from GEMINI_API_KEY in .env",
            "Riverpod providers expose GeminiService app-wide via geminiServiceProvider",
        ]
    )
    story.append(ph1)
    story.append(Spacer(1, 0.3*cm))

    # ── Phase 2 ───────────────────────────────────────────────────────────────
    story.append(Paragraph("Phase 2 — AI Risk Assessment (Health Worker App)", h1_style))
    story.append(hr(WARNING))
    story.append(Paragraph(
        "Health workers can instantly see an AI-generated risk profile for each patient on the "
        "Medical tab of the patient detail screen.", body_style
    ))
    story.append(Spacer(1, 0.2*cm))
    ph2 = phase_table(
        "Phase 2: Risk Assessment Engine", WARNING,
        [
            "RiskAssessmentService — sends patient context to Gemini, returns structured JSON risk assessment",
            "AiRiskAssessment model — riskLevel (LOW/MEDIUM/HIGH), score (0-100), keyFindings, recommendations",
            "AiRiskBanner widget — color-coded banner (green/orange/red) at top of Medical tab",
            "Integrated in patient_detail_screen.dart _MedicalTab (always visible)",
            "24-hour in-memory cache to avoid redundant API calls",
        ]
    )
    story.append(ph2)
    story.append(Spacer(1, 0.3*cm))

    # ── Phase 3 ───────────────────────────────────────────────────────────────
    story.append(Paragraph("Phase 3 — Health Education Chatbot (Patient App)", h1_style))
    story.append(hr(SECONDARY))
    story.append(Paragraph(
        '"Mama AI" — an always-available, conversational health assistant for pregnant mothers and '
        "caregivers, accessible from the home screen and every major education screen.", body_style
    ))
    story.append(Spacer(1, 0.2*cm))
    ph3 = phase_table(
        "Phase 3: Mama AI Chatbot", SECONDARY,
        [
            "ChatbotService — manages conversation history, builds system prompt from patient context",
            "Streaming responses via Gemini — text appears word-by-word for a natural feel",
            "ChatbotProvider (AsyncNotifier) — manages messages, loading state, error recovery",
            "AiChatScreen — full chat UI with message bubbles, input bar, suggestion chips",
            "ChatBubble widget — user vs. AI styling, streaming text display, typing indicator",
            '/ai-chat route added to app_router.dart',
            '"Ask Mama AI" quick-action button added to home_screen.dart',
            '"Ask AI" FABs added to: Must Know, Feeding Guide, Milestones, Healthy Foods screens',
        ]
    )
    story.append(ph3)
    story.append(Spacer(1, 0.3*cm))

    # ── Phase 4 ───────────────────────────────────────────────────────────────
    story.append(Paragraph("Phase 4 — Clinical Decision Support (Health Worker App)", h1_style))
    story.append(hr(PRIMARY))
    story.append(Paragraph(
        "Before recording an ANC visit, health workers get an AI-generated pre-visit briefing "
        "that surfaces key clinical insights from the patient's history.", body_style
    ))
    story.append(Spacer(1, 0.2*cm))
    ph4 = phase_table(
        "Phase 4: Clinical Decision Support", PRIMARY,
        [
            "ClinicalSupportService — generates briefings: suggested questions, overdue screenings, alerts, note starter",
            "ClinicalBriefing model — structured JSON with 4 clinical sections",
            "VisitAiAssistant widget — expandable gradient panel at top of ANC visit recording screen",
            "Alerts shown in amber, overdue screenings in teal, questions in purple",
            "Includes a 'Note Starter' — pre-written clinical note opening based on patient history",
            "Retry button for offline graceful degradation",
            "patientClinicalBriefingProvider — AsyncNotifierProviderFamily (per patient ID)",
        ]
    )
    story.append(ph4)
    story.append(Spacer(1, 0.3*cm))

    # ── Phase 5 ───────────────────────────────────────────────────────────────
    story.append(Paragraph("Phase 5 — Dropout Prevention (Health Worker App)", h1_style))
    story.append(hr(SUCCESS))
    story.append(Paragraph(
        "Proactively identifies patients at risk of missing future appointments, with "
        "AI-generated outreach messages ready to send.", body_style
    ))
    story.append(Spacer(1, 0.2*cm))
    ph5 = phase_table(
        "Phase 5: Dropout Prediction Engine", SUCCESS,
        [
            "DropoutPredictionService — analyzes appointment + visit patterns via Gemini",
            "DropoutPrediction model — risk (LOW/MEDIUM/HIGH), score (0-100), keyRiskFactors",
            "recommendedFollowUpDays — AI-suggested days until next outreach",
            "suggestedOutreachMessage — personalized SMS/message ready to send to patient",
            "patientDropoutPredictionProvider — AsyncNotifierProviderFamily (per patient ID)",
        ]
    )
    story.append(ph5)
    story.append(Spacer(1, 0.3*cm))

    # ── Phase 6 ───────────────────────────────────────────────────────────────
    story.append(Paragraph("Phase 6 — Integration & Polish (Both Apps)", h1_style))
    story.append(hr(MUTED))
    ph6 = phase_table(
        "Phase 6: Polish & Resilience", colors.HexColor("#455A64"),
        [
            "AiUnavailableBanner — shown when offline or API key missing, consistent UX across both apps",
            "All AI providers initialized via Riverpod ProviderScope overrides in main.dart",
            "Import path bugs fixed in ai_chat_screen.dart and chat_bubble.dart",
            "flutter analyze: both apps pass with 0 compilation errors",
        ]
    )
    story.append(ph6)
    story.append(Spacer(1, 0.4*cm))

    # ── File Inventory ────────────────────────────────────────────────────────
    story.append(Paragraph("File Inventory", h1_style))
    story.append(hr())

    story.append(Paragraph("mch_core (Shared Package)", h2_style))
    story.append(file_table([
        ("gemini_service.dart",        "NEW",      "Wraps google_generative_ai SDK"),
        ("patient_context_builder.dart","NEW",     "Builds structured patient context for prompts"),
    ]))
    story.append(Spacer(1, 0.3*cm))

    story.append(Paragraph("mch_health_worker App", h2_style))
    story.append(file_table([
        ("risk_assessment_service.dart",    "NEW",      "Gemini-powered patient risk scoring"),
        ("clinical_support_service.dart",   "NEW",      "Pre-visit AI briefing generator"),
        ("dropout_prediction_service.dart", "NEW",      "Dropout risk prediction + outreach"),
        ("ai_risk_assessment.dart",         "NEW",      "AiRiskAssessment data model"),
        ("ai_providers.dart",               "NEW",      "All Riverpod AI providers (Phases 2–5)"),
        ("ai_risk_banner.dart",             "NEW",      "Color-coded risk display widget"),
        ("visit_ai_assistant.dart",         "NEW",      "Expandable pre-visit briefing panel"),
        ("ai_unavailable_banner.dart",      "NEW",      "Offline/unavailable state widget"),
        ("patient_detail_screen.dart",      "MODIFIED", "AiRiskBanner integrated in Medical tab"),
        ("anc_visit_recording_screen.dart", "MODIFIED", "VisitAiAssistant added above Stepper"),
        ("main.dart",                       "MODIFIED", "GeminiService initialized from .env"),
    ]))
    story.append(Spacer(1, 0.3*cm))

    story.append(Paragraph("mch_patient App", h2_style))
    story.append(file_table([
        ("chatbot_service.dart",              "NEW",      "Streaming chat with history management"),
        ("chatbot_provider.dart",             "NEW",      "AsyncNotifier for chat state"),
        ("ai_chat_screen.dart",               "NEW",      "Full chat UI (Mama AI screen)"),
        ("chat_bubble.dart",                  "NEW",      "User/AI message bubble widget"),
        ("app_router.dart",                   "MODIFIED", "/ai-chat route added"),
        ("home_screen.dart",                  "MODIFIED", '"Ask Mama AI" quick-action added'),
        ("must_know_screen.dart",             "MODIFIED", '"Ask Mama AI" FAB added'),
        ("feeding_guide_screen.dart",         "MODIFIED", '"Ask AI about feeding" FAB added'),
        ("developmental_milestones_screen.dart","MODIFIED",'"Ask AI about milestones" FAB added'),
        ("healthy_foods_screen.dart",         "MODIFIED", '"Ask AI about nutrition" FAB added'),
        ("main.dart",                         "MODIFIED", "GeminiService initialized from .env"),
    ]))
    story.append(Spacer(1, 0.4*cm))

    # ── Technical Architecture ────────────────────────────────────────────────
    story.append(Paragraph("Technical Architecture", h1_style))
    story.append(hr())

    arch_rows = [
        ["Component", "Technology"],
        ["AI Model",        "Google Gemini 1.5 Flash"],
        ["SDK",             "google_generative_ai ^0.4.3"],
        ["State Mgmt",      "flutter_riverpod (AsyncNotifierProvider)"],
        ["Navigation",      "go_router (context.push('/ai-chat'))"],
        ["API Keys",        ".env files (flutter_dotenv) — excluded from git"],
        ["Backend DB",      "Supabase (patient data for AI context)"],
        ["Offline UX",      "AiUnavailableBanner + cached results"],
        ["Response Format", "Structured JSON with markdown stripping"],
    ]
    arch_table = Table(arch_rows, colWidths=[6*cm, 11*cm])
    arch_table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), PRIMARY),
        ("TEXTCOLOR",  (0, 0), (-1, 0), WHITE),
        ("FONTNAME",   (0, 0), (-1, 0), "Helvetica-Bold"),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [WHITE, LIGHT_BG]),
        ("FONTNAME",   (0, 1), (-1, -1), "Helvetica"),
        ("FONTSIZE",   (0, 0), (-1, -1), 9.5),
        ("GRID",       (0, 0), (-1, -1), 0.4, colors.HexColor("#CCCCDD")),
        ("TOPPADDING",    (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
        ("LEFTPADDING",   (0, 0), (-1, -1), 10),
        ("RIGHTPADDING",  (0, 0), (-1, -1), 10),
    ]))
    story.append(arch_table)
    story.append(Spacer(1, 0.4*cm))

    # ── Analyze Results ───────────────────────────────────────────────────────
    story.append(Paragraph("Verification Results", h1_style))
    story.append(hr(SUCCESS))
    verify_rows = [
        ["App", "flutter analyze", "Notes"],
        ["mch_health_worker", "✅  PASS (0 errors)", "266 info-level lint warnings (withOpacity deprecations)"],
        ["mch_patient",       "✅  PASS (0 errors)", "Info-level lint warnings only"],
    ]
    verify_table = Table(verify_rows, colWidths=[4.5*cm, 4.5*cm, 8*cm])
    verify_table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), SUCCESS),
        ("TEXTCOLOR",  (0, 0), (-1, 0), WHITE),
        ("FONTNAME",   (0, 0), (-1, 0), "Helvetica-Bold"),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [WHITE, LIGHT_BG]),
        ("FONTNAME",   (0, 1), (-1, -1), "Helvetica"),
        ("FONTSIZE",   (0, 0), (-1, -1), 9.5),
        ("GRID",       (0, 0), (-1, -1), 0.4, colors.HexColor("#CCCCDD")),
        ("TOPPADDING",    (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
        ("LEFTPADDING",   (0, 0), (-1, -1), 10),
        ("RIGHTPADDING",  (0, 0), (-1, -1), 10),
    ]))
    story.append(verify_table)
    story.append(Spacer(1, 0.5*cm))

    # ── Footer ────────────────────────────────────────────────────────────────
    story.append(hr(MUTED))
    story.append(Paragraph(
        f"Generated by Antigravity AI  •  {datetime.now().strftime('%B %d, %Y at %H:%M')}  •  MCH Kenya",
        small_style
    ))

    doc.build(story)
    print(f"✅  PDF generated: {OUTPUT_PATH}")


if __name__ == "__main__":
    build_pdf()
