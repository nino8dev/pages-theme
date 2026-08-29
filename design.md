# design.md — ビジュアルデザインガイド (pages-theme)

`nino8dev` サイトのテーマ実装における、見た目の一貫性を保つためのルールです。
サイトの目的・ポジショニング・コンテンツポリシーは
[`nino8dev/design.md`](https://github.com/nino8dev/nino8dev/blob/main/design.md) を参照してください。
元の構築プロンプト全文は
[`nino8dev/docs/build-prompt.md`](https://github.com/nino8dev/nino8dev/blob/main/docs/build-prompt.md)。

## コンセプト(1行)

**見た目は2000年代前半の個人ホームページ、内部実装はモダン・データ駆動。**
「懐かしさ・手作り感・テキスト中心の情報量」を意図的に残す。現代的に洗練させすぎない。

参考: 阿部寛氏のホームページ的な高速・軽量・テキスト中心の思想(ただしそこまで簡素にはせず、
罫線ボックスやバナーなど装飾はやや増やす)。

## 配色トークン (`_sass/base/_variables.scss`)

実装済みの値。新しいコンポーネントもここに定義した変数を使うこと(直書き禁止)。

| 変数 | 値 | 用途 |
|---|---|---|
| `$color-bg` | `#f5f3ea` | 背景(生成り紙風) |
| `$color-bg-inset` | `#fbfaf4` | 罫線ボックス内背景 |
| `$color-text` | `#1f2328` | 本文 |
| `$color-text-soft` | `#4a4f57` | 補足文字 |
| `$color-border` | `#9c9788` | 通常罫線 |
| `$color-border-strong` | `#4a4f57` | 強調・二重線 |
| `$color-navy` | `#1a2b4c` | 紺(見出し・ヘッダー・アクセント) |
| `$color-wine` | `#7b1e28` | えんじ(アクセント・矢印・NEWラベル系) |
| `$color-green` | `#1f4d3a` | 深緑 |
| `$color-gray` | `#55524a` | 灰色 |
| `$color-link` | `#0000ee` | 未訪問リンク(懐かしの青) — 固定 |
| `$color-link-visited` | `#551a8b` | 訪問済みリンク(紫) — 固定 |
| `$color-link-hover` | `#b30000` | リンクhover |
| `$color-header-bg` / `$color-header-fg` | `#1a2b4c` / `#f5f3ea` | サイトヘッダー |
| `$color-new-label` | `#c1121f` | 「NEW!」等の小ラベル |

**リンク色(青→紫→赤hover)は変更しない。** 2000年代サイトらしさの核となる要素。
配色はWCAG AA (4.5:1) のコントラストを満たすこと — 変更時は必ず確認する。

## 寸法・フォント

- `$content-width: 880px`(固定幅・中央寄せ。800〜960pxの範囲を維持)
- `$sidebar-width: 180px`(左サイドナビ。640px以下は縦積みに変わる — `_layout.scss` 参照)
- 罫線は `$border-width-thin: 1px` / `$border-width-thick: 2px` のみ使用
- 本文フォントはシステムフォント優先(`$font-base`)。Webフォントは導入しない。
- 等幅フォント `$font-mono` は「部分的に」使う(コード的表現・強調に留め、本文全体には使わない)
- `$font-size-base: 15px` / `line-height: 1.85` — 情報量の多いテキストサイトとして読みやすさ優先
- 見出しは小さめ(`h1: 1.5rem` 〜 `h3: 1.05rem`)。巨大な見出しにしない。

## やること(既存実装のパターンを踏襲)

- 罫線付きボックス(`.main-content`, `.site-nav`, `.breadcrumb` は1px実線 + 薄い背景)
- 見出しの装飾: `h1`下線(二重線相当の太さ)、`h2`左罫線、`h3`前に`▶`(えんじ色)
- パンくずリスト、ページ最上部へ戻るリンく(`.back-to-top`)、フッターのサイトマップ風リンク列
- 200×40pxのSVGバナー(`assets/images/banners/`)。単純な形状・少ない色数・ピクセル風文字
- 更新日表示・「NEW!」等の小さなラベル
- ナビゲーションの各項目に `・`(えんじ色)の行頭記号(`site-nav__list a::before`)
- 訪問中ページは `aria-current="page"` + えんじ色 + 太字で強調

## やらないこと(避けるデザイン)

- 全画面ヒーロー画像・巨大グラデーション
- SaaSランディングページ風・過度なカードUI
- 大きすぎる余白、大量の角丸、半透明ガラスUI(glassmorphism)
- スクロールアニメーション主体の演出、意味のない3D表現
- スキルを円グラフ・パーセント表示にする
- AI生成の人物画像・ストックフォト
- 廃止HTML要素(`marquee`, `blink`, `font`, レイアウト目的の`table`)— 見た目の再現はCSSで行う
- Webフォントの追加、外部CDNへの依存

## アクセシビリティ / 実装品質(妥協しない項目)

- セマンティックHTML5、適切な見出し階層
- 全リンク・画像に `alt` / 十分なコントラスト
- キーボード操作対応、`:focus-visible` に可視スタイル(現状 `outline: 2px dashed $color-wine`)
- `prefers-reduced-motion` に対応(アニメーションを足す場合は必須)
- JavaScript依存は最小限。追加する場合も外部ライブラリなしで書く
- テーマ本体(`pages-theme`)側の変更は、`nino8dev` 側で `_config.local.yml` によるローカル参照
  (`gem "pages-theme", path: "../pages-theme"`)で即座に確認できる。
  本番は `nino8dev/_config.yml` の `remote_theme: nino8dev/pages-theme@main` を使うため、
  変更を公開するには `pages-theme` を `main` にpush(タグ運用していないため即時反映)する必要がある。

## 新しいコンポーネントを追加するときのチェックリスト

1. 色は `_sass/base/_variables.scss` の変数を使う(直書きしない)
2. 罫線・二重線・点線などレトロ表現は既存パターン(`_layout.scss` / `_typography.scss`)に倣う
3. モバイル(640px以下)での崩れを確認する
4. コントラスト比・フォーカス表示・alt属性を確認する
5. 「現代的に洗練させすぎていないか」を最後に自問する — 素朴さ・情報量の多さは意図的な仕様
