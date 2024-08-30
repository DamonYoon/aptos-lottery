import { WalletSelector } from "./WalletSelector";

export function Header() {
  return (
    <div className="flex items-center justify-between px-4 py-2 max-w-screen-xl mx-auto w-full flex-wrap">
      <div className="flex flex-row gap-2">
        <h1 className="display">Draw</h1>
        <h1 className="display text-primary">Winners</h1>
      </div>

      <div className="flex gap-2 items-center flex-wrap">
        <WalletSelector />
      </div>
    </div>
  );
}
